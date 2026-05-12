-- Bitbucket PR comments overlay provider.
-- Built via M.new(atlas_client). Emits normalized comments per
-- `lua/config/my/diff/CONTEXT.md` (anchor = { side, line }).
local links = require("config.my.diff.providers.bitbucket_links")
local lib = require("config.my.diff.lib")

local M = {}

---@param url string  origin URL (ssh or https)
---@return string|nil workspace, string|nil repo
local function parse_origin_url(url)
  if type(url) ~= "string" or url == "" then return nil end
  if not url:find("bitbucket", 1, true) then return nil end

  local path = url:match("^[%w_-]+@[^:]+:(.+)$")
    or url:match("^https?://[^/]+/(.+)$")
    or url:match("^[%w]+://[^/]+/(.+)$")
  if not path then return nil end

  path = path:gsub("%.git$", "")
  local workspace, repo = path:match("^([^/]+)/(.+)$")
  if not workspace or not repo then return nil end
  return workspace, repo
end

local function parse_origin(root)
  local url = lib.git.origin_url(root)
  if not url then return nil end
  return parse_origin_url(url)
end

local function hash_matches(left, right)
  left = tostring(left or "")
  right = tostring(right or "")
  return left ~= "" and right ~= "" and (left:sub(1, #right) == right or right:sub(1, #left) == left)
end

local function iso_for_popup(value)
  if type(value) ~= "string" then return nil end
  return value:gsub("%.%d+", ""):gsub("%+00:00$", "Z")
end

-- Translate one Bitbucket comment payload into the normalized shape
-- defined in CONTEXT.md. Anchor side is RIGHT when inline.to is set
-- (modern line in the new revision), LEFT when only inline.from is set.
local function normalize_comment(comment)
  local inline = comment.inline or {}
  local to_line = tonumber(inline.to)
  local from_line = tonumber(inline["from"])
  local side = to_line and "RIGHT" or "LEFT"
  local end_line = to_line or from_line
  local start_line = end_line
  if to_line then
    start_line = tonumber(inline.start_to) or end_line
  elseif from_line then
    start_line = tonumber(inline.start_from) or end_line
  end

  local author = comment.author or comment.user or {}
  local content = comment.content or {}
  local parent = comment.parent or {}
  local user = (author.nickname ~= "" and author.nickname) or author.name or author.display_name

  local raw = comment._raw or comment
  local result = {
    id = comment.id,
    _raw = raw,
    path = inline.path,
    body = comment.content_raw or content.raw or "",
    user = user,
    user_id = author.account_id or author.uuid,
    created_at = iso_for_popup(comment.created_on or (raw and raw.created_on)),
    pending = comment.pending == true or tostring(comment.state or ""):upper() == "PENDING",
    in_reply_to_id = comment.parent_id or parent.id,
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

  -- First pass: thread roots (have inline path + line of their own).
  for _, comment in ipairs(comments or {}) do
    local item = normalize_comment(comment)
    if item.path and item.anchor then
      table.insert(normalized, item)
      by_id[item.id] = item
    end
  end

  -- Second pass: replies inherit anchor + path + range from their root.
  for _, comment in ipairs(comments or {}) do
    local item = normalize_comment(comment)
    if item.in_reply_to_id and not item.path then
      local parent_item = by_id[item.in_reply_to_id]
      if parent_item then
        item.path = parent_item.path
        item.anchor = parent_item.anchor
        item.range = parent_item.range
        table.insert(normalized, item)
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

local function inline_for(context)
  if context.side == "LEFT" then
    return {
      path = context.file_path,
      ["from"] = context.end_line,
      start_from = context.start_line ~= context.end_line and context.start_line or nil,
    }
  end
  return {
    path = context.file_path,
    to = context.end_line,
    start_to = context.start_line ~= context.end_line and context.start_line or nil,
  }
end

M._normalize_comments = normalize_comments
M._parse_origin_url = parse_origin_url

---@param atlas_client table  see providers/atlas_client.lua
---@return table|nil  provider table, or nil when atlas_client is missing
function M.new(atlas_client)
  if not atlas_client then return nil end

  local provider = { name = "bitbucket" }

  function provider.parse_origin_url(url)
    return parse_origin_url(url)
  end

  function provider.can_handle(session)
    return session ~= nil and parse_origin(session.git_root) ~= nil
  end

  local function pr_from_revision(session, callback)
    if not session or not session.git_root then callback(nil); return end
    local workspace, repo = parse_origin(session.git_root)
    if not workspace or not repo then callback(nil); return end

    local sha = tostring(session.modified_revision or "")
    atlas_client.fetch_open_prs(workspace, repo, function(prs, err)
      if err then callback(nil, err); return end
      for _, pr in ipairs(prs or {}) do
        local source_hash = (pr.source or {}).commit_hash
        if hash_matches(source_hash, sha) then
          callback(pr); return
        end
      end
      callback(nil)
    end)
  end

  local function pr_from_branch_internal(workspace, repo, branch, callback)
    if not workspace or not repo or not branch or branch == "" then callback(nil); return end
    atlas_client.fetch_open_prs(workspace, repo, function(prs, err)
      if err then callback(nil, err); return end
      for _, pr in ipairs(prs or {}) do
        local source_branch = (pr.source or {}).branch
        if source_branch == branch then callback(pr); return end
      end
      callback(nil)
    end)
  end

  local function pr_from_branch(session, callback)
    if not session or not session.git_root then callback(nil); return end
    local workspace, repo = parse_origin(session.git_root)
    if not workspace or not repo then callback(nil); return end

    local branch = session.modified_branch
    if not branch or branch == "" then
      branch = lib.git.current_branch(session.git_root) or ""
    end
    pr_from_branch_internal(workspace, repo, branch, callback)
  end

  function provider.find_pr(session, callback)
    pr_from_revision(session, function(pr, err)
      if err then callback(nil, "Failed to find Bitbucket PR: " .. err); return end
      if pr then callback(pr); return end
      pr_from_branch(session, function(pr2, err2)
        if err2 then callback(nil, "Failed to find Bitbucket PR: " .. err2); return end
        if not pr2 then callback(nil, "No Bitbucket PR found"); return end
        callback(pr2)
      end)
    end)
  end

  function provider.find_pr_for_branch(workspace, repo, branch, callback)
    pr_from_branch_internal(workspace, repo, branch, function(pr, err)
      if err then callback(nil, "Failed to find Bitbucket PR: " .. err); return end
      if not pr then callback(nil, ("No open PR for branch %s"):format(branch)); return end
      callback(pr)
    end)
  end

  function provider.fetch_diff_files(pr, callback)
    local url = links.diff(pr)
    if url == "" then callback({}); return end

    atlas_client.fetch_diff(url, { force_load = true }, function(diff, _err)
      local by_path = {}
      for _, file in ipairs(diff or {}) do
        local path = file.path or file.new_path
        if path then by_path[path] = file end
        if file.old_path and file.old_path ~= "" then by_path[file.old_path] = file end
      end
      callback(by_path)
    end)
  end

  function provider.fetch_comments(pr, callback)
    local url = links.comments(pr)
    if url == "" then
      callback(nil, "Failed to load comments: no comments URL")
      return
    end

    atlas_client.fetch_comments(url, function(values, err)
      if err then callback(nil, "Failed to load comments: " .. err); return end
      for _, c in ipairs(values or {}) do c._raw = c end
      callback(dedup(normalize_comments(values)))
    end)
  end

  function provider.add_comment(pr, context, body, opts, callback)
    local url = links.comments(pr)
    if url == "" then callback(nil, "No comments URL available"); return end

    local inline = inline_for(context)
    atlas_client.create_comment(url, body, { inline = inline }, function(result, err)
      if err then callback(nil, "Failed to post comment: " .. err); return end
      callback(result)
    end)
  end

  function provider.reply(pr, root_comment, body, callback)
    local url = links.comments(pr)
    if url == "" then callback(nil, "No comments URL available"); return end

    atlas_client.reply_comment(url, root_comment.id, body, nil, function(result, err)
      if err then callback(nil, "Failed to post reply: " .. err); return end
      callback(result)
    end)
  end

  function provider.submit_review(pr, event, body, callback)
    local action_url, action
    if event == "APPROVE" then
      action_url, action = links.approve(pr), "approve"
    elseif event == "REQUEST_CHANGES" then
      action_url, action = links.request_changes(pr), "request_changes"
    else
      callback(nil, "Unsupported Bitbucket review event: " .. tostring(event))
      return
    end

    if action_url == "" then
      callback(nil, action == "approve" and "No approve URL available" or "No request changes URL available")
      return
    end

    local function submit_action()
      local fn = action == "approve" and atlas_client.approve or atlas_client.request_changes
      fn(action_url, function(result, err)
        if err then
          callback(nil, (action == "approve" and "Approve failed: " or "Request changes failed: ") .. tostring(err))
          return
        end
        callback(result or true)
      end)
    end

    if body and body ~= "" then
      local url = links.comments(pr)
      if url ~= "" then
        atlas_client.create_comment(url, body, {}, function(_, err)
          if err then callback(nil, "Failed to post review comment: " .. tostring(err)); return end
          submit_action()
        end)
        return
      end
    end
    submit_action()
  end

  function provider.edit_comment(pr, comment, body, callback)
    if not comment or not comment.id then
      callback(nil, "No comment selected"); return
    end

    local edit_opts = {}
    local raw_inline = (comment._raw or {}).inline
    if type(raw_inline) == "table" then edit_opts.inline = raw_inline end

    atlas_client.edit_comment(pr, comment.id, body, edit_opts, function(result, err)
      if err then callback(nil, "Failed to edit comment: " .. tostring(err)); return end
      callback(result)
    end)
  end

  function provider.fetch_current_user(callback)
    atlas_client.fetch_current_user(function(user, err)
      if err then callback(nil, err); return end
      callback(user)
    end)
  end

  function provider.delete_comment(_pr, comment, callback)
    if not comment or not comment.id then
      callback(nil, "No comment selected"); return
    end

    local self_url = links.self(comment)
    if self_url == "" then
      callback(nil, "No self URL on comment"); return
    end

    atlas_client.delete_comment(self_url, function(_, err)
      if err then callback(nil, "Failed to delete comment: " .. tostring(err)); return end
      callback(true)
    end)
  end

  function provider.pr_url(pr)
    return links.html(pr)
  end

  return provider
end

return M
