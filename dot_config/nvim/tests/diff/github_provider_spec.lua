-- GitHub provider factory. Drives M.new(stub_client) and verifies the
-- provider delegates to the gh client and routes per-PR endpoints correctly.
package.loaded["config.my.diff.providers.github"] = nil
local github = require("config.my.diff.providers.github")

local function stub_client()
  local c = { calls = {} }
  c.next = {}

  local function record(name, args)
    table.insert(c.calls, { name = name, args = args })
  end

  function c.fetch_open_prs(workspace, repo, cb)
    record("fetch_open_prs", { workspace, repo })
    local n = c.next.fetch_open_prs or { result = {}, err = nil }
    cb(n.result, n.err)
  end
  function c.fetch_pr_files(pr, cb)
    record("fetch_pr_files", { pr })
    local n = c.next.fetch_pr_files or { result = {}, err = nil }
    cb(n.result, n.err)
  end
  function c.fetch_review_comments(pr, cb)
    record("fetch_review_comments", { pr })
    local n = c.next.fetch_review_comments or { result = {}, err = nil }
    cb(n.result, n.err)
  end
  function c.create_review_comment(pr, payload, cb)
    record("create_review_comment", { pr, payload })
    local n = c.next.create_review_comment or { result = { id = 1 }, err = nil }
    cb(n.result, n.err)
  end
  function c.reply_review_comment(pr, parent_id, body, cb)
    record("reply_review_comment", { pr, parent_id, body })
    local n = c.next.reply_review_comment or { result = { id = 2 }, err = nil }
    cb(n.result, n.err)
  end
  function c.delete_review_comment(pr, comment_id, cb)
    record("delete_review_comment", { pr, comment_id })
    local n = c.next.delete_review_comment or { result = true, err = nil }
    cb(n.result, n.err)
  end
  function c.edit_review_comment(pr, comment_id, body, cb)
    record("edit_review_comment", { pr, comment_id, body })
    local n = c.next.edit_review_comment or { result = { id = comment_id }, err = nil }
    cb(n.result, n.err)
  end
  function c.submit_review(pr, event, body, cb)
    record("submit_review", { pr, event, body })
    local n = c.next.submit_review or { result = true, err = nil }
    cb(n.result, n.err)
  end
  function c.fetch_current_user(cb)
    record("fetch_current_user", {})
    local n = c.next.fetch_current_user or { result = { login = "me", id = 1 }, err = nil }
    cb(n.result, n.err)
  end

  return c
end

local function make_pr(overrides)
  local pr = {
    number = 7,
    head = { sha = "deadbeef", ref = "feature" },
    base = { repo = { full_name = "owner/repo" } },
    review_comments_url = "https://api.github.com/repos/owner/repo/pulls/7/comments",
    html_url = "https://github.com/owner/repo/pull/7",
  }
  if overrides then for k, v in pairs(overrides) do pr[k] = v end end
  return pr
end

describe("github.new", function()
  it("returns nil when gh_client is nil", function()
    assert.is_nil(github.new(nil))
  end)

  it("returns provider table when client is present", function()
    local p = github.new(stub_client())
    assert.is_not_nil(p)
    assert.equals("github", p.name)
    for _, fn in ipairs({
      "parse_origin_url", "can_handle", "find_pr", "find_pr_for_branch",
      "fetch_diff_files", "fetch_comments", "add_comment", "reply",
      "submit_review", "delete_comment", "edit_comment", "fetch_current_user",
      "pr_url",
    }) do
      assert.is_function(p[fn], fn .. " missing")
    end
  end)
end)

describe("github.parse_origin_url", function()
  local p
  before_each(function() p = github.new(stub_client()) end)

  it("parses ssh URLs", function()
    local ws, repo = p.parse_origin_url("git@github.com:owner/repo.git")
    assert.equals("owner", ws)
    assert.equals("repo", repo)
  end)

  it("parses https URLs", function()
    local ws, repo = p.parse_origin_url("https://github.com/owner/repo.git")
    assert.equals("owner", ws)
    assert.equals("repo", repo)
  end)

  it("strips .git suffix", function()
    local _, repo = p.parse_origin_url("https://github.com/owner/repo.git")
    assert.equals("repo", repo)
  end)

  it("returns nil for non-github URLs", function()
    assert.is_nil(p.parse_origin_url("git@bitbucket.org:owner/repo.git"))
    assert.is_nil(p.parse_origin_url(""))
    assert.is_nil(p.parse_origin_url(nil))
  end)
end)

describe("github.find_pr_for_branch", function()
  it("matches by head.ref", function()
    local client = stub_client()
    client.next.fetch_open_prs = { result = {
      { number = 1, head = { ref = "other" } },
      { number = 2, head = { ref = "feature" } },
    }, err = nil }
    local p = github.new(client)
    local found, err
    p.find_pr_for_branch("owner", "repo", "feature", function(pr, e) found, err = pr, e end)
    assert.is_nil(err)
    assert.equals(2, found.number)
  end)

  it("errors when no PR matches", function()
    local client = stub_client()
    client.next.fetch_open_prs = { result = {}, err = nil }
    local p = github.new(client)
    local found, err
    p.find_pr_for_branch("owner", "repo", "feature", function(pr, e) found, err = pr, e end)
    assert.is_nil(found)
    assert.matches("feature", err)
  end)

  it("propagates client error with prefix", function()
    local client = stub_client()
    client.next.fetch_open_prs = { result = nil, err = "down" }
    local p = github.new(client)
    local found, err
    p.find_pr_for_branch("owner", "repo", "feature", function(pr, e) found, err = pr, e end)
    assert.is_nil(found)
    assert.matches("down", err)
  end)
end)

describe("github.fetch_diff_files", function()
  it("groups by filename and previous_filename", function()
    local client = stub_client()
    client.next.fetch_pr_files = { result = {
      { filename = "a.lua", patch = "@@ -1,1 +1,1 @@", previous_filename = "old_a.lua" },
      { filename = "b.lua", patch = "@@ -1,2 +1,2 @@" },
    }, err = nil }
    local p = github.new(client)
    local files
    p.fetch_diff_files(make_pr(), function(f) files = f end)
    assert.is_not_nil(files["a.lua"])
    assert.is_not_nil(files["old_a.lua"])
    assert.is_not_nil(files["b.lua"])
  end)
end)

describe("github.fetch_comments", function()
  it("normalizes review comments and includes range", function()
    local client = stub_client()
    client.next.fetch_review_comments = { result = {
      { id = 1, path = "a.lua", line = 5, side = "RIGHT", body = "hi", user = { login = "u", id = 1 } },
      { id = 2, in_reply_to_id = 1, body = "reply", user = { login = "u2", id = 2 } },
    }, err = nil }
    local p = github.new(client)
    local res, err
    p.fetch_comments(make_pr(), function(r, e) res, err = r, e end)
    assert.is_nil(err)
    assert.equals(2, #res)
    -- Reply inherits anchor + path + range from root.
    local reply = res[2]
    assert.equals("a.lua", reply.path)
    assert.equals(5, reply.anchor.line)
    assert.equals("RIGHT", reply.anchor.side)
    assert.is_not_nil(reply.range)
    assert.equals(5, reply.range.start_line)
    assert.equals(5, reply.range.end_line)
  end)

  it("multi-line comments populate range.start_line/end_line", function()
    local client = stub_client()
    client.next.fetch_review_comments = { result = {
      { id = 1, path = "a.lua", line = 10, start_line = 5, side = "RIGHT", body = "multi",
        user = { login = "u", id = 1 } },
    }, err = nil }
    local p = github.new(client)
    local res
    p.fetch_comments(make_pr(), function(r) res = r end)
    assert.equals(5, res[1].range.start_line)
    assert.equals(10, res[1].range.end_line)
  end)

  it("propagates client error with prefix", function()
    local client = stub_client()
    client.next.fetch_review_comments = { result = nil, err = "down" }
    local p = github.new(client)
    local res, err
    p.fetch_comments(make_pr(), function(r, e) res, err = r, e end)
    assert.is_nil(res)
    assert.matches("Failed to load comments", err)
    assert.matches("down", err)
  end)
end)

describe("github.add_comment", function()
  it("posts payload with commit_id, path, side, line", function()
    local client = stub_client()
    local p = github.new(client)
    p.add_comment(make_pr(), { file_path = "a.lua", start_line = 12, end_line = 12, side = "RIGHT" },
      "body", {}, function() end)
    local payload = client.calls[1].args[2]
    assert.equals("body", payload.body)
    assert.equals("deadbeef", payload.commit_id)
    assert.equals("a.lua", payload.path)
    assert.equals("RIGHT", payload.side)
    assert.equals(12, payload.line)
    assert.is_nil(payload.start_line)
  end)

  it("posts start_line + start_side for multi-line", function()
    local client = stub_client()
    local p = github.new(client)
    p.add_comment(make_pr(), { file_path = "a.lua", start_line = 10, end_line = 12, side = "LEFT" },
      "body", {}, function() end)
    local payload = client.calls[1].args[2]
    assert.equals(10, payload.start_line)
    assert.equals("LEFT", payload.start_side)
    assert.equals(12, payload.line)
  end)
end)

describe("github.reply", function()
  it("delegates to gh_client.reply_review_comment with parent id and body", function()
    local client = stub_client()
    local p = github.new(client)
    p.reply(make_pr(), { id = 99 }, "yo", function() end)
    assert.equals("reply_review_comment", client.calls[1].name)
    assert.equals(99, client.calls[1].args[2])
    assert.equals("yo", client.calls[1].args[3])
  end)

  it("errors when root has no id", function()
    local p = github.new(stub_client())
    local res, err
    p.reply(make_pr(), {}, "yo", function(r, e) res, err = r, e end)
    assert.is_nil(res)
    assert.matches("No root comment id", err)
  end)
end)

describe("github.delete_comment", function()
  it("delegates to gh_client.delete_review_comment", function()
    local client = stub_client()
    local p = github.new(client)
    p.delete_comment(make_pr(), { id = 7 }, function() end)
    assert.equals(7, client.calls[1].args[2])
  end)

  it("errors when no id", function()
    local p = github.new(stub_client())
    local ok, err
    p.delete_comment(make_pr(), {}, function(r, e) ok, err = r, e end)
    assert.is_nil(ok)
    assert.matches("No comment selected", err)
  end)
end)

describe("github.submit_review", function()
  it("calls submit_review with APPROVE", function()
    local client = stub_client()
    local p = github.new(client)
    p.submit_review(make_pr(), "APPROVE", "lgtm", function() end)
    assert.equals("submit_review", client.calls[1].name)
    assert.equals("APPROVE", client.calls[1].args[2])
    assert.equals("lgtm", client.calls[1].args[3])
  end)

  it("rejects unknown event", function()
    local p = github.new(stub_client())
    local res, err
    p.submit_review(make_pr(), "MERGE", "", function(r, e) res, err = r, e end)
    assert.is_nil(res)
    assert.matches("Unsupported", err)
  end)
end)

describe("github.fetch_current_user", function()
  it("normalizes login → username", function()
    local client = stub_client()
    client.next.fetch_current_user = { result = { login = "me", id = 42, name = "Me Real" }, err = nil }
    local p = github.new(client)
    local user
    p.fetch_current_user(function(u) user = u end)
    assert.equals(42, user.id)
    assert.equals("me", user.username)
    assert.equals("Me Real", user.display_name)
  end)
end)

describe("github.pr_url", function()
  it("returns html_url", function()
    local p = github.new(stub_client())
    assert.equals("https://github.com/owner/repo/pull/7", p.pr_url(make_pr()))
  end)

  it("returns empty string when missing", function()
    local p = github.new(stub_client())
    assert.equals("", p.pr_url({}))
  end)
end)
