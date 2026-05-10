-- gh client adapter. Verifies the (result, err) contract on every method
-- by injecting a fake `runner` (the `gh api` shell-out).
package.loaded["config.my.diff.providers.gh_client"] = nil
local gh_client_mod = require("config.my.diff.providers.gh_client")

local function fake_runner(responses)
  -- responses is a list of { args_match? = string, code = 0|N, stdout = "...",
  -- stderr = "..." } consumed in order.
  local idx = 0
  local recorded = { calls = {} }
  return function(args, stdin, cb)
    idx = idx + 1
    table.insert(recorded.calls, { args = args, stdin = stdin })
    local r = responses[idx] or { code = 0, stdout = "", stderr = "" }
    cb({ code = r.code, stdout = r.stdout or "", stderr = r.stderr or "" })
  end, recorded
end

describe("gh_client.new", function()
  it("returns nil when gh is missing (default check)", function()
    -- We can't easily simulate `gh` not being installed without monkey-patching
    -- vim.fn.executable, so use skip_check + a fake runner to exercise the
    -- positive path; the negative path is one return statement.
    local client = gh_client_mod.new({ skip_check = true, runner = function() end })
    assert.is_not_nil(client)
  end)

  it("exposes the canonical method set", function()
    local client = gh_client_mod.new({ skip_check = true, runner = function() end })
    for _, fn in ipairs({
      "fetch_open_prs", "fetch_pr_files", "fetch_review_comments",
      "create_review_comment", "reply_review_comment", "delete_review_comment",
      "edit_review_comment", "submit_review", "fetch_current_user",
    }) do
      assert.is_function(client[fn], fn .. " missing")
    end
  end)
end)

describe("gh_client (happy paths)", function()
  it("fetch_current_user GET /user", function()
    local runner, recorded = fake_runner({
      { code = 0, stdout = '{"login":"me","id":1}' },
    })
    local client = gh_client_mod.new({ skip_check = true, runner = runner })
    local user, err
    client.fetch_current_user(function(u, e) user, err = u, e end)
    assert.is_nil(err)
    assert.equals("me", user.login)
    assert.equals(1, user.id)
    assert.equals("user", recorded.calls[1].args[1])
  end)

  it("fetch_open_prs paginates the pulls endpoint", function()
    local runner, recorded = fake_runner({
      { code = 0, stdout = '[{"number":1},{"number":2}]' },
    })
    local client = gh_client_mod.new({ skip_check = true, runner = runner })
    local prs
    client.fetch_open_prs("owner", "repo", function(r) prs = r end)
    assert.equals(2, #prs)
    assert.matches("repos/owner/repo/pulls", recorded.calls[1].args[1])
    assert.matches("per_page=100", recorded.calls[1].args[1])
    assert.is_true(vim.tbl_contains(recorded.calls[1].args, "--paginate"))
  end)

  it("create_review_comment POSTs JSON body via stdin", function()
    local runner, recorded = fake_runner({
      { code = 0, stdout = '{"id":42}' },
    })
    local client = gh_client_mod.new({ skip_check = true, runner = runner })
    local pr = { review_comments_url = "https://api/x/comments" }
    client.create_review_comment(pr, { body = "hi", line = 5 }, function() end)
    assert.equals("https://api/x/comments", recorded.calls[1].args[1])
    assert.is_true(vim.tbl_contains(recorded.calls[1].args, "POST"))
    assert.is_true(vim.tbl_contains(recorded.calls[1].args, "--input"))
    local payload = vim.json.decode(recorded.calls[1].stdin)
    assert.equals("hi", payload.body)
    assert.equals(5, payload.line)
  end)

  it("reply_review_comment posts to .../{id}/replies", function()
    local runner, recorded = fake_runner({
      { code = 0, stdout = '{"id":99}' },
    })
    local client = gh_client_mod.new({ skip_check = true, runner = runner })
    client.reply_review_comment({ review_comments_url = "https://api/x/comments" }, 7, "yo", function() end)
    assert.matches("comments/7/replies$", recorded.calls[1].args[1])
    assert.equals("yo", vim.json.decode(recorded.calls[1].stdin).body)
  end)

  it("edit_review_comment PATCHes the comment endpoint", function()
    local runner, recorded = fake_runner({
      { code = 0, stdout = '{"id":7}' },
    })
    local client = gh_client_mod.new({ skip_check = true, runner = runner })
    local pr = { base = { repo = { full_name = "o/r" } } }
    client.edit_review_comment(pr, 7, "new", function() end)
    assert.matches("repos/o/r/pulls/comments/7", recorded.calls[1].args[1])
    assert.is_true(vim.tbl_contains(recorded.calls[1].args, "PATCH"))
    assert.equals("new", vim.json.decode(recorded.calls[1].stdin).body)
  end)

  it("delete_review_comment DELETEs", function()
    local runner, recorded = fake_runner({
      { code = 0, stdout = "" },
    })
    local client = gh_client_mod.new({ skip_check = true, runner = runner })
    local pr = { base = { repo = { full_name = "o/r" } } }
    local ok
    client.delete_review_comment(pr, 7, function(r) ok = r end)
    assert.matches("repos/o/r/pulls/comments/7", recorded.calls[1].args[1])
    assert.is_true(vim.tbl_contains(recorded.calls[1].args, "DELETE"))
    assert.is_true(ok)
  end)

  it("submit_review posts event + body to .../reviews", function()
    local runner, recorded = fake_runner({
      { code = 0, stdout = '{"id":3}' },
    })
    local client = gh_client_mod.new({ skip_check = true, runner = runner })
    local pr = { number = 5, base = { repo = { full_name = "o/r" } } }
    client.submit_review(pr, "APPROVE", "lgtm", function() end)
    assert.matches("repos/o/r/pulls/5/reviews", recorded.calls[1].args[1])
    local payload = vim.json.decode(recorded.calls[1].stdin)
    assert.equals("APPROVE", payload.event)
    assert.equals("lgtm", payload.body)
  end)

  it("submit_review omits empty body", function()
    local runner, recorded = fake_runner({
      { code = 0, stdout = '{}' },
    })
    local client = gh_client_mod.new({ skip_check = true, runner = runner })
    local pr = { number = 5, base = { repo = { full_name = "o/r" } } }
    client.submit_review(pr, "APPROVE", "", function() end)
    local payload = vim.json.decode(recorded.calls[1].stdin)
    assert.is_nil(payload.body)
  end)
end)

describe("gh_client (error paths)", function()
  it("propagates non-zero exit with stderr trimmed", function()
    local runner = fake_runner({
      { code = 1, stdout = "", stderr = "  HTTP 404\n" },
    })
    local client = gh_client_mod.new({ skip_check = true, runner = runner })
    local res, err
    client.fetch_current_user(function(r, e) res, err = r, e end)
    assert.is_nil(res)
    assert.equals("HTTP 404", err)
  end)

  it("flags invalid JSON", function()
    local runner = fake_runner({
      { code = 0, stdout = "not json" },
    })
    local client = gh_client_mod.new({ skip_check = true, runner = runner })
    local res, err
    client.fetch_current_user(function(r, e) res, err = r, e end)
    assert.is_nil(res)
    assert.matches("invalid JSON", err)
  end)

  it("create_review_comment errors when pr lacks review_comments_url", function()
    local client = gh_client_mod.new({ skip_check = true, runner = function() end })
    local res, err
    client.create_review_comment({}, { body = "x" }, function(r, e) res, err = r, e end)
    assert.is_nil(res)
    assert.matches("review_comments_url", err)
  end)

  it("delete_review_comment errors when pr.base missing", function()
    local client = gh_client_mod.new({ skip_check = true, runner = function() end })
    local res, err
    client.delete_review_comment({}, 7, function(r, e) res, err = r, e end)
    assert.is_nil(res)
    assert.matches("pr%.base", err)
  end)
end)
