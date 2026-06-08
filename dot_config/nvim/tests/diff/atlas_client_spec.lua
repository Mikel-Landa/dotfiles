-- Atlas client adapter. Verifies missing-dep => nil at construction,
-- and strict (result, err) contract on every method.
package.loaded["config.my.diff.providers.atlas_client"] = nil
local atlas_client_mod = require("config.my.diff.providers.atlas_client")

local function make_deps(overrides)
  local recorded = { calls = {} }
  local function record(name)
    return function(...)
      table.insert(recorded.calls, { name = name, args = { ... } })
    end
  end

  local deps = {
    ["atlas.pulls.providers.bitbucket.api.service"] = {
      request = function(method, url, body, headers, cb)
        table.insert(recorded.calls, { name = "service.request", args = { method, url, body, headers } })
        if recorded.next_request then
          local nr = recorded.next_request; recorded.next_request = nil
          cb(nr.result, nr.err)
        else
          cb({ values = {} }, nil)
        end
      end,
    },
    ["atlas.pulls.providers.bitbucket.api.mapper"] = {
      to_pull_requests_list = function(_result, workspace, repo)
        return { { id = 1, _ws = workspace, _repo = repo } }
      end,
    },
    ["atlas.pulls.providers.bitbucket.api.pullrequests"] = {
      fetch_diff = function(pr, opts, cb)
        table.insert(recorded.calls, { name = "pullrequests.fetch_diff", args = { pr, opts } })
        cb(recorded.diff_result, recorded.diff_err)
      end,
      approve = function(url, cb)
        table.insert(recorded.calls, { name = "pullrequests.approve", args = { url } })
        cb(recorded.approve_result, recorded.approve_err)
      end,
      request_changes = function(url, cb)
        table.insert(recorded.calls, { name = "pullrequests.request_changes", args = { url } })
        cb(recorded.request_changes_result, recorded.request_changes_err)
      end,
    },
    ["atlas.pulls.providers.bitbucket.api.comments"] = {
      add_comment = function(pr, body, opts, cb)
        table.insert(recorded.calls, { name = "comments.add_comment", args = { pr, body, opts } })
        cb(recorded.create_result, recorded.create_err)
      end,
      reply_comment = function(pr, parent_id, body, opts, cb)
        table.insert(recorded.calls, { name = "comments.reply_comment", args = { pr, parent_id, body, opts } })
        cb(recorded.reply_result, recorded.reply_err)
      end,
      delete_comment = function(pr, comment_id, cb)
        table.insert(recorded.calls, { name = "comments.delete_comment", args = { pr, comment_id } })
        cb(recorded.delete_ok, recorded.delete_err)
      end,
      edit_comment = function(pr, comment_id, body, opts, cb)
        table.insert(recorded.calls, { name = "comments.edit_comment", args = { pr, comment_id, body, opts } })
        cb(recorded.edit_result, recorded.edit_err)
      end,
    },
    ["atlas.pulls.providers.bitbucket.api.users"] = {
      fetch_current_user = function(cb)
        table.insert(recorded.calls, { name = "users.fetch_current_user", args = {} })
        cb(recorded.user_result, recorded.user_err)
      end,
    },
  }

  local missing = {}
  if overrides then
    for k, v in pairs(overrides) do deps[k] = v end
    if overrides._missing then
      for _, mod in ipairs(overrides._missing) do missing[mod] = true end
    end
  end

  local function loader(mod)
    if missing[mod] then return nil end
    return deps[mod]
  end
  return recorded, loader
end

describe("atlas_client.new", function()
  it("returns nil when service module missing", function()
    local _, loader = make_deps({ _missing = { "atlas.pulls.providers.bitbucket.api.service" } })
    assert.is_nil(atlas_client_mod.new({ require = loader }))
  end)

  it("returns nil when mapper missing", function()
    local _, loader = make_deps({ _missing = { "atlas.pulls.providers.bitbucket.api.mapper" } })
    assert.is_nil(atlas_client_mod.new({ require = loader }))
  end)

  it("returns nil when pullrequests missing", function()
    local _, loader = make_deps({ _missing = { "atlas.pulls.providers.bitbucket.api.pullrequests" } })
    assert.is_nil(atlas_client_mod.new({ require = loader }))
  end)

  it("returns nil when comments missing", function()
    local _, loader = make_deps({ _missing = { "atlas.pulls.providers.bitbucket.api.comments" } })
    assert.is_nil(atlas_client_mod.new({ require = loader }))
  end)

  it("returns client when all deps present", function()
    local _, loader = make_deps()
    local client = atlas_client_mod.new({ require = loader })
    assert.is_not_nil(client)
    assert.is_function(client.fetch_open_prs)
    assert.is_function(client.fetch_diff)
    assert.is_function(client.fetch_comments)
    assert.is_function(client.create_comment)
    assert.is_function(client.reply_comment)
    assert.is_function(client.delete_comment)
    assert.is_function(client.approve)
    assert.is_function(client.request_changes)
  end)
end)

describe("atlas_client.fetch_open_prs", function()
  it("issues the right endpoint and returns normalized prs", function()
    local recorded, loader = make_deps()
    local client = atlas_client_mod.new({ require = loader })
    local result, err
    client.fetch_open_prs("ws", "repo", function(r, e) result, err = r, e end)
    assert.is_nil(err)
    assert.equals(1, #result)
    assert.equals("ws", result[1]._ws)
    assert.equals("repo", result[1]._repo)
    assert.equals("/repositories/ws/repo/pullrequests?state=OPEN&pagelen=50", recorded.calls[1].args[2])
  end)

  it("propagates service errors as (nil, err)", function()
    local recorded, loader = make_deps()
    recorded.next_request = { result = nil, err = "boom" }
    local client = atlas_client_mod.new({ require = loader })
    local result, err
    client.fetch_open_prs("ws", "repo", function(r, e) result, err = r, e end)
    assert.is_nil(result)
    assert.equals("boom", err)
  end)
end)

describe("atlas_client.fetch_comments", function()
  it("appends pagelen=100 and unwraps result.values", function()
    local recorded, loader = make_deps()
    recorded.next_request = { result = { values = { { id = 1 }, { id = 2 } } }, err = nil }
    local client = atlas_client_mod.new({ require = loader })
    local values, err
    client.fetch_comments("https://api/comments", function(v, e) values, err = v, e end)
    assert.is_nil(err)
    assert.equals(2, #values)
    assert.equals("https://api/comments?pagelen=100", recorded.calls[1].args[2])
  end)

  it("uses & when url already has a query string", function()
    local recorded, loader = make_deps()
    local client = atlas_client_mod.new({ require = loader })
    client.fetch_comments("https://api/comments?fields=x", function() end)
    assert.equals("https://api/comments?fields=x&pagelen=100", recorded.calls[1].args[2])
  end)

  it("propagates service errors as (nil, err)", function()
    local recorded, loader = make_deps()
    recorded.next_request = { result = nil, err = "down" }
    local client = atlas_client_mod.new({ require = loader })
    local values, err
    client.fetch_comments("https://api/c", function(v, e) values, err = v, e end)
    assert.is_nil(values)
    assert.equals("down", err)
  end)
end)

describe("atlas_client.fetch_diff", function()
  it("delegates to pullrequests.fetch_diff with pr + opts and returns diff", function()
    local recorded, loader = make_deps()
    recorded.diff_result = { { path = "a.lua" } }
    local client = atlas_client_mod.new({ require = loader })
    local diff, err
    client.fetch_diff({ id = 7 }, { force_load = true }, function(d, e) diff, err = d, e end)
    assert.is_nil(err)
    assert.equals("a.lua", diff[1].path)
    assert.equals(7, recorded.calls[1].args[1].id)
    assert.is_true(recorded.calls[1].args[2].force_load)
  end)

  it("propagates errors as (nil, err)", function()
    local recorded, loader = make_deps()
    recorded.diff_err = "fail"
    local client = atlas_client_mod.new({ require = loader })
    local diff, err
    client.fetch_diff({ id = 1 }, nil, function(d, e) diff, err = d, e end)
    assert.is_nil(diff)
    assert.equals("fail", err)
  end)
end)

describe("atlas_client mutations", function()
  it("create_comment delegates to add_comment, relays result + err", function()
    local recorded, loader = make_deps()
    recorded.create_result = { id = 5 }
    local client = atlas_client_mod.new({ require = loader })
    local result, err
    client.create_comment({ id = 9 }, "body", { inline = { path = "x" } }, function(r, e) result, err = r, e end)
    assert.equals(5, result.id)
    assert.is_nil(err)
    assert.equals("comments.add_comment", recorded.calls[1].name)
    assert.equals(9, recorded.calls[1].args[1].id)
    assert.equals("body", recorded.calls[1].args[2])
  end)

  it("reply_comment passes pr + parent_id through", function()
    local recorded, loader = make_deps()
    local client = atlas_client_mod.new({ require = loader })
    client.reply_comment({ id = 9 }, 42, "body", nil, function() end)
    assert.equals(9, recorded.calls[1].args[1].id)
    assert.equals(42, recorded.calls[1].args[2])
  end)

  it("delete_comment passes pr + comment_id, maps falsy ok to (nil, err)", function()
    local recorded, loader = make_deps()
    recorded.delete_ok = false
    recorded.delete_err = nil
    local client = atlas_client_mod.new({ require = loader })
    local ok, err
    client.delete_comment({ id = 9 }, 123, function(r, e) ok, err = r, e end)
    assert.is_nil(ok)
    assert.is_string(err)
    assert.equals(9, recorded.calls[1].args[1].id)
    assert.equals(123, recorded.calls[1].args[2])
  end)

  it("delete_comment maps truthy ok to (true, nil)", function()
    local recorded, loader = make_deps()
    recorded.delete_ok = true
    local client = atlas_client_mod.new({ require = loader })
    local ok, err
    client.delete_comment({ id = 9 }, 123, function(r, e) ok, err = r, e end)
    assert.is_true(ok)
    assert.is_nil(err)
  end)

  it("approve and request_changes relay (result, err)", function()
    local recorded, loader = make_deps()
    recorded.approve_result = { state = "APPROVED" }
    local client = atlas_client_mod.new({ require = loader })
    local result, err
    client.approve("u", function(r, e) result, err = r, e end)
    assert.equals("APPROVED", result.state)
    assert.is_nil(err)

    recorded.request_changes_err = "rc fail"
    client.request_changes("u", function(r, e) result, err = r, e end)
    assert.is_nil(result)
    assert.equals("rc fail", err)
  end)
end)
