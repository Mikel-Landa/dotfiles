-- gh client. Single adapter onto the `gh` CLI for GitHub PR review-comment APIs.
-- See CONTEXT.md → "gh client". Returns nil from M.new() when `gh` is missing
-- or unauthenticated, in which case init.lua skips registering the GitHub
-- provider. Every method follows the (result, err) callback contract.
local M = {}

local function default_runner(args, stdin, cb)
  vim.system({ "gh", "api", unpack(args) }, { stdin = stdin, text = true }, function(out)
    vim.schedule(function() cb(out) end)
  end)
end

local function parse_json(text)
  if type(text) ~= "string" or text == "" then return nil, "empty response" end
  local ok, decoded = pcall(vim.json.decode, text, { luanil = { object = true, array = true } })
  if not ok then return nil, "invalid JSON: " .. tostring(decoded) end
  return decoded, nil
end

local function gh_available(opts)
  if opts and opts.skip_check then return true end
  if vim.fn.executable("gh") ~= 1 then return false end
  return true
end

---@param opts? { runner?: fun(args: string[], stdin: string|nil, cb: fun(out: vim.SystemCompleted)), skip_check?: boolean }
---@return table|nil
function M.new(opts)
  opts = opts or {}
  if not gh_available(opts) then return nil end

  local runner = opts.runner or default_runner
  local client = {}

  local function api(args, stdin, cb)
    runner(args, stdin, function(out)
      if not out or out.code ~= 0 then
        local err = (out and out.stderr) or "gh api failed"
        cb(nil, vim.trim(tostring(err)))
        return
      end
      if out.stdout == "" or out.stdout == nil then
        cb(true, nil); return
      end
      local data, parse_err = parse_json(out.stdout)
      if parse_err then cb(nil, parse_err); return end
      cb(data, nil)
    end)
  end

  local function get(path, cb)
    api({ path }, nil, cb)
  end

  local function post_json(path, payload, cb)
    api({ path, "-X", "POST", "--input", "-" }, vim.json.encode(payload), cb)
  end

  local function patch_json(path, payload, cb)
    api({ path, "-X", "PATCH", "--input", "-" }, vim.json.encode(payload), cb)
  end

  local function delete(path, cb)
    api({ path, "-X", "DELETE" }, nil, cb)
  end

  local function paged_get(path, cb)
    local sep = path:find("?") and "&" or "?"
    api({ ("%s%sper_page=100"):format(path, sep), "--paginate" }, nil, cb)
  end

  function client.fetch_open_prs(workspace, repo, cb)
    paged_get(("repos/%s/%s/pulls?state=open"):format(workspace, repo), function(result, err)
      if err then cb(nil, err); return end
      cb(result or {}, nil)
    end)
  end

  function client.fetch_pr_files(pr, cb)
    if not pr or not pr.number or not pr.base then cb(nil, "missing pr.number or pr.base"); return end
    local repo = (pr.base.repo or {})
    local full = repo.full_name
    if not full then cb(nil, "missing pr.base.repo.full_name"); return end
    paged_get(("repos/%s/pulls/%d/files"):format(full, pr.number), function(result, err)
      if err then cb(nil, err); return end
      cb(result or {}, nil)
    end)
  end

  function client.fetch_review_comments(pr, cb)
    if not pr or not pr.review_comments_url then cb(nil, "missing pr.review_comments_url"); return end
    paged_get(pr.review_comments_url, function(result, err)
      if err then cb(nil, err); return end
      cb(result or {}, nil)
    end)
  end

  function client.create_review_comment(pr, payload, cb)
    if not pr or not pr.review_comments_url then cb(nil, "missing pr.review_comments_url"); return end
    post_json(pr.review_comments_url, payload, cb)
  end

  function client.reply_review_comment(pr, parent_id, body, cb)
    if not pr or not pr.review_comments_url then cb(nil, "missing pr.review_comments_url"); return end
    post_json(("%s/%d/replies"):format(pr.review_comments_url, parent_id), { body = body }, cb)
  end

  function client.delete_review_comment(pr, comment_id, cb)
    if not pr or not pr.base then cb(nil, "missing pr.base"); return end
    local full = (pr.base.repo or {}).full_name
    if not full then cb(nil, "missing pr.base.repo.full_name"); return end
    delete(("repos/%s/pulls/comments/%d"):format(full, comment_id), cb)
  end

  function client.edit_review_comment(pr, comment_id, body, cb)
    if not pr or not pr.base then cb(nil, "missing pr.base"); return end
    local full = (pr.base.repo or {}).full_name
    if not full then cb(nil, "missing pr.base.repo.full_name"); return end
    patch_json(("repos/%s/pulls/comments/%d"):format(full, comment_id), { body = body }, cb)
  end

  function client.submit_review(pr, event, body, cb)
    if not pr or not pr.number or not pr.base then cb(nil, "missing pr.number or pr.base"); return end
    local full = (pr.base.repo or {}).full_name
    if not full then cb(nil, "missing pr.base.repo.full_name"); return end
    local payload = { event = event }
    if body and body ~= "" then payload.body = body end
    post_json(("repos/%s/pulls/%d/reviews"):format(full, pr.number), payload, cb)
  end

  function client.fetch_current_user(cb)
    get("user", cb)
  end

  return client
end

return M
