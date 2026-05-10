-- Bitbucket provider factory. Drives M.new(stub_client) and verifies the
-- provider delegates to the atlas client and routes per-PR URLs correctly.
package.loaded["config.my.diff.providers.bitbucket"] = nil
local bitbucket = require("config.my.diff.providers.bitbucket")

local function stub_client()
  local c = { calls = {} }
  local function record(name, args, result, err)
    table.insert(c.calls, { name = name, args = args })
    return result, err
  end

  c.next = {} -- per-method canned responses: c.next.fetch_diff = { result, err }

  function c.fetch_open_prs(workspace, repo, cb)
    table.insert(c.calls, { name = "fetch_open_prs", args = { workspace, repo } })
    local n = c.next.fetch_open_prs or { result = {}, err = nil }
    cb(n.result, n.err)
  end
  function c.fetch_diff(url, opts, cb)
    table.insert(c.calls, { name = "fetch_diff", args = { url, opts } })
    local n = c.next.fetch_diff or { result = {}, err = nil }
    cb(n.result, n.err)
  end
  function c.fetch_comments(url, cb)
    table.insert(c.calls, { name = "fetch_comments", args = { url } })
    local n = c.next.fetch_comments or { result = {}, err = nil }
    cb(n.result, n.err)
  end
  function c.create_comment(url, body, opts, cb)
    table.insert(c.calls, { name = "create_comment", args = { url, body, opts } })
    local n = c.next.create_comment or { result = { id = 1 }, err = nil }
    cb(n.result, n.err)
  end
  function c.reply_comment(url, parent_id, body, opts, cb)
    table.insert(c.calls, { name = "reply_comment", args = { url, parent_id, body, opts } })
    local n = c.next.reply_comment or { result = { id = 2 }, err = nil }
    cb(n.result, n.err)
  end
  function c.delete_comment(url, cb)
    table.insert(c.calls, { name = "delete_comment", args = { url } })
    local n = c.next.delete_comment or { result = true, err = nil }
    cb(n.result, n.err)
  end
  function c.approve(url, cb)
    table.insert(c.calls, { name = "approve", args = { url } })
    local n = c.next.approve or { result = true, err = nil }
    cb(n.result, n.err)
  end
  function c.request_changes(url, cb)
    table.insert(c.calls, { name = "request_changes", args = { url } })
    local n = c.next.request_changes or { result = true, err = nil }
    cb(n.result, n.err)
  end

  return c
end

local function make_pr(links)
  return { _raw = { links = links or {} } }
end

describe("bitbucket.new", function()
  it("returns nil when atlas_client is nil", function()
    assert.is_nil(bitbucket.new(nil))
  end)

  it("returns provider table when client is present", function()
    local p = bitbucket.new(stub_client())
    assert.is_not_nil(p)
    assert.equals("bitbucket", p.name)
    for _, fn in ipairs({
      "can_handle", "find_pr", "fetch_diff_files", "fetch_comments",
      "add_comment", "reply", "submit_review", "delete_comment", "pr_url",
    }) do
      assert.is_function(p[fn], fn .. " missing")
    end
  end)
end)

describe("bitbucket.fetch_diff_files", function()
  it("returns {} when pr has no diff link", function()
    local p = bitbucket.new(stub_client())
    local files
    p.fetch_diff_files(make_pr({}), function(f) files = f end)
    assert.are.same({}, files)
  end)

  it("groups by path and old_path", function()
    local client = stub_client()
    client.next.fetch_diff = { result = {
      { path = "a.lua", old_path = "old_a.lua" },
      { new_path = "b.lua" },
    }, err = nil }
    local p = bitbucket.new(client)
    local files
    p.fetch_diff_files(make_pr({ diff = { href = "http://diff" } }), function(f) files = f end)
    assert.is_not_nil(files["a.lua"])
    assert.is_not_nil(files["old_a.lua"])
    assert.is_not_nil(files["b.lua"])
    assert.equals("http://diff", client.calls[1].args[1])
    assert.is_true(client.calls[1].args[2].force_load)
  end)
end)

describe("bitbucket.fetch_comments", function()
  it("errors when pr has no comments link", function()
    local p = bitbucket.new(stub_client())
    local res, err
    p.fetch_comments(make_pr({}), function(r, e) res, err = r, e end)
    assert.is_nil(res)
    assert.is_string(err)
  end)

  it("normalizes + dedups comments from the client", function()
    local client = stub_client()
    client.next.fetch_comments = { result = {
      { id = 1, inline = { path = "a.lua", to = 5 }, content = { raw = "hi" } },
      { id = 1, inline = { path = "a.lua", to = 5 }, content = { raw = "hi" } }, -- dup
      { id = 2, parent = { id = 1 }, content = { raw = "reply" } },
    }, err = nil }
    local p = bitbucket.new(client)
    local res, err
    p.fetch_comments(make_pr({ comments = { href = "http://c" } }), function(r, e) res, err = r, e end)
    assert.is_nil(err)
    assert.equals(2, #res) -- dup dropped, root + reply kept
    assert.equals("http://c", client.calls[1].args[1])
  end)

  it("propagates client error with prefix", function()
    local client = stub_client()
    client.next.fetch_comments = { result = nil, err = "down" }
    local p = bitbucket.new(client)
    local res, err
    p.fetch_comments(make_pr({ comments = { href = "http://c" } }), function(r, e) res, err = r, e end)
    assert.is_nil(res)
    assert.matches("Failed to load comments", err)
    assert.matches("down", err)
  end)
end)

describe("bitbucket.add_comment", function()
  it("posts inline.to for RIGHT side", function()
    local client = stub_client()
    local p = bitbucket.new(client)
    p.add_comment(
      make_pr({ comments = { href = "http://c" } }),
      { file_path = "a.lua", start_line = 10, end_line = 12, side = "RIGHT" },
      "body", { pending = true }, function() end
    )
    local args = client.calls[1].args
    assert.equals("http://c", args[1])
    assert.equals("body", args[2])
    assert.equals(12, args[3].inline.to)
    assert.equals(10, args[3].inline.start_to)
    assert.equals("a.lua", args[3].inline.path)
  end)

  it("posts inline.from for LEFT side", function()
    local client = stub_client()
    local p = bitbucket.new(client)
    p.add_comment(
      make_pr({ comments = { href = "http://c" } }),
      { file_path = "a.lua", start_line = 5, end_line = 5, side = "LEFT" },
      "body", {}, function() end
    )
    local args = client.calls[1].args
    assert.equals(5, args[3].inline["from"])
    assert.is_nil(args[3].inline.start_from) -- single-line
  end)
end)

describe("bitbucket.reply", function()
  it("passes the root comment id as parent_id", function()
    local client = stub_client()
    local p = bitbucket.new(client)
    p.reply(make_pr({ comments = { href = "http://c" } }), { id = 99 }, "yo", function() end)
    assert.equals(99, client.calls[1].args[2])
  end)
end)

describe("bitbucket.delete_comment", function()
  it("uses the comment._raw.links.self.href", function()
    local client = stub_client()
    local p = bitbucket.new(client)
    p.delete_comment(nil,
      { id = 7, _raw = { links = { self = { href = "http://self" } } } },
      function() end)
    assert.equals("http://self", client.calls[1].args[1])
  end)

  it("errors when no self URL", function()
    local p = bitbucket.new(stub_client())
    local ok, err
    p.delete_comment(nil, { id = 7, _raw = { links = {} } }, function(r, e) ok, err = r, e end)
    assert.is_nil(ok)
    assert.matches("self URL", err)
  end)

  it("errors when no id", function()
    local p = bitbucket.new(stub_client())
    local ok, err
    p.delete_comment(nil, {}, function(r, e) ok, err = r, e end)
    assert.is_nil(ok)
    assert.matches("No comment selected", err)
  end)
end)

describe("bitbucket.submit_review", function()
  it("calls approve when event=APPROVE", function()
    local client = stub_client()
    local p = bitbucket.new(client)
    p.submit_review(make_pr({ approve = { href = "http://approve" } }),
      "APPROVE", "", function() end)
    assert.equals("approve", client.calls[1].name)
    assert.equals("http://approve", client.calls[1].args[1])
  end)

  it("calls request_changes when event=REQUEST_CHANGES with hyphenated key", function()
    local client = stub_client()
    local p = bitbucket.new(client)
    p.submit_review(make_pr({ ["request-changes"] = { href = "http://rc" } }),
      "REQUEST_CHANGES", "", function() end)
    assert.equals("request_changes", client.calls[1].name)
    assert.equals("http://rc", client.calls[1].args[1])
  end)

  it("posts review comment first when body is non-empty", function()
    local client = stub_client()
    local p = bitbucket.new(client)
    p.submit_review(
      make_pr({ approve = { href = "http://a" }, comments = { href = "http://c" } }),
      "APPROVE", "looks good", function() end)
    assert.equals("create_comment", client.calls[1].name)
    assert.equals("http://c", client.calls[1].args[1])
    assert.equals("approve", client.calls[2].name)
  end)

  it("rejects unknown event", function()
    local client = stub_client()
    local p = bitbucket.new(client)
    local res, err
    p.submit_review(make_pr({}), "MERGE", "", function(r, e) res, err = r, e end)
    assert.is_nil(res)
    assert.matches("Unsupported", err)
  end)

  it("errors when approve URL missing", function()
    local p = bitbucket.new(stub_client())
    local res, err
    p.submit_review(make_pr({}), "APPROVE", "", function(r, e) res, err = r, e end)
    assert.is_nil(res)
    assert.matches("approve URL", err)
  end)
end)

describe("bitbucket.pr_url", function()
  it("extracts html.href", function()
    local p = bitbucket.new(stub_client())
    assert.equals("http://html", p.pr_url(make_pr({ html = { href = "http://html" } })))
  end)
end)

describe("bitbucket.parse_origin_url", function()
  local p
  before_each(function() p = bitbucket.new(stub_client()) end)

  it("parses ssh URLs", function()
    local ws, repo = p.parse_origin_url("git@bitbucket.org:owner/repo.git")
    assert.equals("owner", ws)
    assert.equals("repo", repo)
  end)

  it("parses https URLs", function()
    local ws, repo = p.parse_origin_url("https://bitbucket.org/owner/repo.git")
    assert.equals("owner", ws)
    assert.equals("repo", repo)
  end)

  it("returns nil for non-bitbucket URLs", function()
    assert.is_nil(p.parse_origin_url("git@github.com:o/r.git"))
    assert.is_nil(p.parse_origin_url(""))
    assert.is_nil(p.parse_origin_url(nil))
  end)
end)

describe("bitbucket.find_pr_for_branch", function()
  it("matches by source.branch", function()
    local client = stub_client()
    client.next.fetch_open_prs = { result = {
      { id = 1, source = { branch = "other" } },
      { id = 2, source = { branch = "feature" } },
    }, err = nil }
    local p = bitbucket.new(client)
    local found, err
    p.find_pr_for_branch("ws", "repo", "feature", function(pr, e) found, err = pr, e end)
    assert.is_nil(err)
    assert.equals(2, found.id)
  end)

  it("errors when no PR matches", function()
    local client = stub_client()
    client.next.fetch_open_prs = { result = {}, err = nil }
    local p = bitbucket.new(client)
    local found, err
    p.find_pr_for_branch("ws", "repo", "feature", function(pr, e) found, err = pr, e end)
    assert.is_nil(found)
    assert.matches("feature", err)
  end)

  it("propagates client error with prefix", function()
    local client = stub_client()
    client.next.fetch_open_prs = { result = nil, err = "down" }
    local p = bitbucket.new(client)
    local found, err
    p.find_pr_for_branch("ws", "repo", "feature", function(pr, e) found, err = pr, e end)
    assert.is_nil(found)
    assert.matches("down", err)
  end)
end)
