-- GitHub PR comments overlay provider.
-- Built via M.new(gh_client). Emits normalized comments per
-- `lua/config/my/diff/CONTEXT.md` (anchor = { side, line }).
local M = {}

local function trim(value)
  if type(value) ~= "string" then return "" end
  return vim.trim(value)
end

---@param url string  origin URL (ssh or https)
---@return string|nil workspace, string|nil repo
local function parse_origin_url(url)
  if type(url) ~= "string" or url == "" then return nil end
  if not url:find("github.com", 1, true) then return nil end

  local path = url:match("^[%w_-]+@github%.com:(.+)$")
    or url:match("^https?://[^/]+@?github%.com/(.+)$")
    or url:match("^https?://github%.com/(.+)$")
  if not path then return nil end

  path = path:gsub("%.git$", "")
  local workspace, repo = path:match("^([^/]+)/(.+)$")
  if not workspace or not repo then return nil end
  return workspace, repo
end

local function origin_url_for(git_root)
  if type(git_root) ~= "string" or git_root == "" then return nil end
  local result = vim.system({ "git", "-C", git_root, "remote", "get-url", "origin" }, { text = true }):wait()
  if not result or result.code ~= 0 then return nil end
  return trim(result.stdout)
end

local function parse_origin(git_root)
  local url = origin_url_for(git_root)
  if not url then return nil end
  return parse_origin_url(url)
end

-- Translate one GitHub review-comment payload into the normalized shape
-- defined in CONTEXT.md. GitHub side is "RIGHT" or "LEFT" directly. line is
-- the modern PR-file line; falls back to original_line when null (outdated).
local function normalize_comment(comment)
  local user = comment.user or {}
  local raw = comment._raw or comment

  local side = comment.side or "RIGHT"
  if side ~= "LEFT" and side ~= "RIGHT" then side = "RIGHT" end
  local end_line = tonumber(comment.line) or tonumber(comment.original_line)
  local start_line = tonumber(comment.start_line) or end_line

  local result = {
    id = comment.id,
    _raw = raw,
    path = comment.path,
    body = comment.body or "",
    user = user.login,
    user_id = user.id,
    created_at = comment.created_at,
    pending = false,
    in_reply_to_id = comment.in_reply_to_id,
  }
  if result.path and end_line then
    result.anchor = { side = side, line = end_line }
    if start_line and start_line ~= end_line then
      result.range = { start_line = math.min(start_line, end_line), end_line = math.max(start_line, end_line) }
    else
      result.range = { start_line = end_line, end_line = end_line }
    end
  end
  return result
end

local function normalize_comments(comments)
  local normalized = {}
  local by_id = {}

  -- First pass: thread roots (have inline path + line of their own, no parent).
  for _, comment in ipairs(comments or {}) do
    if not comment.in_reply_to_id then
      local item = normalize_comment(comment)
      if item.path and item.anchor then
        table.insert(normalized, item)
        by_id[item.id] = item
      end
    end
  end

  -- Second pass: replies inherit anchor + path + range from their root if missing.
  for _, comment in ipairs(comments or {}) do
    if comment.in_reply_to_id then
      local item = normalize_comment(comment)
      local parent_item = by_id[item.in_reply_to_id]
      if parent_item then
        item.path = item.path or parent_item.path
        item.anchor = item.anchor or parent_item.anchor
        item.range = item.range or parent_item.range
        if item.path and item.anchor then
          table.insert(normalized, item)
        end
      end
    end
  end

  return normalized
end

local function dedup(comments)
  local out = {}
  local seen = {}
  for _, comment in ipairs(comments or {}) do
    if comment.path and comment.anchor then
      local key = tostring(comment.id or "")
      if key == "" then
        key = table.concat({
          comment.path or "", comment.anchor.side or "",
          tostring(comment.anchor.line or ""), comment.body or "",
        }, ":")
      end
      if not seen[key] then
        seen[key] = true
        table.insert(out, comment)
      end
    end
  end
  return out
end

-- Test seam: expose normalize_comments for fixture-driven specs (static).
M._normalize_comments = normalize_comments
M._parse_origin_url = parse_origin_url

---@param gh_client table  see providers/gh_client.lua
---@return table|nil  provider table, or nil when gh_client is missing
function M.new(gh_client)
  if not gh_client then return nil end

  local provider = { name = "github" }

  function provider.parse_origin_url(url)
    return parse_origin_url(url)
  end

  function provider.can_handle(session)
    if not session or not session.git_root then return false end
    return parse_origin(session.git_root) ~= nil
  end

  local function pr_from_revision(session, callback)
    local workspace, repo = parse_origin(session.git_root)
    if not workspace or not repo then callback(nil); return end

    local sha = tostring(session.modified_revision or "")
    gh_client.fetch_open_prs(workspace, repo, function(prs, err)
      if err then callback(nil, err); return end
      for _, pr in ipairs(prs or {}) do
        local head_sha = (pr.head or {}).sha
        if head_sha and sha ~= "" and (head_sha:sub(1, #sha) == sha or sha:sub(1, #head_sha) == head_sha) then
          callback(pr); return
        end
      end
      callback(nil)
    end)
  end

  local function pr_from_branch_internal(workspace, repo, branch, callback)
    if not workspace or not repo or not branch or branch == "" then callback(nil); return end
    gh_client.fetch_open_prs(workspace, repo, function(prs, err)
      if err then callback(nil, err); return end
      for _, pr in ipairs(prs or {}) do
        if (pr.head or {}).ref == branch then callback(pr); return end
      end
      callback(nil)
    end)
  end

  local function pr_from_branch(session, callback)
    local workspace, repo = parse_origin(session.git_root)
    if not workspace or not repo then callback(nil); return end
    local branch = session.modified_branch
    if not branch or branch == "" then
      local result = vim.system({ "git", "-C", session.git_root, "rev-parse", "--abbrev-ref", "HEAD" }, { text = true }):wait()
      branch = result and result.code == 0 and trim(result.stdout) or ""
    end
    pr_from_branch_internal(workspace, repo, branch, callback)
  end

  local function wait_for_pr(session, attempt, callback)
    attempt = attempt or 1
    pr_from_revision(session, function(pr, err)
      if pr or err then callback(pr, err); return end
      if attempt >= 6 then
        pr_from_branch(session, callback)
        return
      end
      vim.defer_fn(function() wait_for_pr(session, attempt + 1, callback) end, 100)
    end)
  end

  function provider.find_pr(session, callback)
    wait_for_pr(session, 1, function(pr, err)
      if err then callback(nil, "Failed to find GitHub PR: " .. err); return end
      if not pr then callback(nil, "No GitHub PR found"); return end
      callback(pr)
    end)
  end

  function provider.find_pr_for_branch(workspace, repo, branch, callback)
    pr_from_branch_internal(workspace, repo, branch, function(pr, err)
      if err then callback(nil, "Failed to find GitHub PR: " .. err); return end
      if not pr then callback(nil, ("No open PR for branch %s"):format(branch)); return end
      callback(pr)
    end)
  end

  function provider.fetch_diff_files(pr, callback)
    gh_client.fetch_pr_files(pr, function(files, err)
      if err then callback({}); return end
      local by_path = {}
      for _, file in ipairs(files or {}) do
        local path = file.filename
        if path then
          by_path[path] = { path = path, patch = file.patch or "", raw = file.patch or "" }
        end
        if file.previous_filename and file.previous_filename ~= "" then
          by_path[file.previous_filename] = by_path[path]
        end
      end
      callback(by_path)
    end)
  end

  function provider.fetch_comments(pr, callback)
    gh_client.fetch_review_comments(pr, function(values, err)
      if err then callback(nil, "Failed to load comments: " .. err); return end
      for _, c in ipairs(values or {}) do c._raw = c end
      callback(dedup(normalize_comments(values)))
    end)
  end

  function provider.add_comment(pr, context, body, opts, callback)
    if not pr or not pr.head or not pr.head.sha then
      callback(nil, "PR has no head sha"); return
    end
    local payload = {
      body = body,
      commit_id = pr.head.sha,
      path = context.file_path,
      side = context.side,
      line = context.end_line,
    }
    if context.start_line and context.start_line ~= context.end_line then
      payload.start_line = context.start_line
      payload.start_side = context.side
    end
    gh_client.create_review_comment(pr, payload, function(result, err)
      if err then callback(nil, "Failed to post comment: " .. err); return end
      callback(result)
    end)
  end

  function provider.reply(pr, root_comment, body, callback)
    if not root_comment or not root_comment.id then
      callback(nil, "No root comment id"); return
    end
    gh_client.reply_review_comment(pr, root_comment.id, body, function(result, err)
      if err then callback(nil, "Failed to post reply: " .. err); return end
      callback(result)
    end)
  end

  function provider.submit_review(pr, event, body, callback)
    if event ~= "APPROVE" and event ~= "REQUEST_CHANGES" and event ~= "COMMENT" then
      callback(nil, "Unsupported GitHub review event: " .. tostring(event))
      return
    end
    gh_client.submit_review(pr, event, body or "", function(result, err)
      if err then callback(nil, ("%s failed: %s"):format(event, err)); return end
      callback(result or true)
    end)
  end

  function provider.edit_comment(pr, comment, body, callback)
    if not comment or not comment.id then
      callback(nil, "No comment selected"); return
    end
    gh_client.edit_review_comment(pr, comment.id, body, function(result, err)
      if err then callback(nil, "Failed to edit comment: " .. err); return end
      callback(result)
    end)
  end

  function provider.delete_comment(pr, comment, callback)
    if not comment or not comment.id then
      callback(nil, "No comment selected"); return
    end
    gh_client.delete_review_comment(pr, comment.id, function(_, err)
      if err then callback(nil, "Failed to delete comment: " .. err); return end
      callback(true)
    end)
  end

  function provider.fetch_current_user(callback)
    gh_client.fetch_current_user(function(user, err)
      if err then callback(nil, err); return end
      if not user then callback(nil); return end
      callback({
        id = user.id,
        username = user.login,
        display_name = user.name or user.login,
        _raw = user,
      })
    end)
  end

  function provider.pr_url(pr)
    return tostring((pr or {}).html_url or "")
  end

  return provider
end

return M
