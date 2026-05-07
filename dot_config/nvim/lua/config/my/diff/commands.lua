-- User-facing commands for the PR comments overlay.
-- See CONTEXT.md → "commands.lua".
local M = {}

local registry = require("config.my.diff.registry")
local diffview_session = require("config.my.diff.diffview_session")
local comments_ui = require("config.my.diff.comments_ui")
local hunks = require("config.my.diff.hunks")

local function notify(level, msg)
  vim.notify("[PR comments] " .. tostring(msg), level)
end

local function in_diff(tabpage, file_path, start_line, end_line, side)
  local s = registry.get(tabpage)
  if not s then return false end
  local file = s.diff_files[file_path]
  if not file then return false end
  return hunks.contains(hunks.parse(file), start_line, end_line, side)
end

local function current_context()
  local tabpage = vim.api.nvim_get_current_tabpage()
  local view_session = diffview_session.read(tabpage)
  if not view_session then
    notify(vim.log.levels.WARN, "Not in a Diffview session")
    return nil
  end
  local file_path = diffview_session.rel_file_path(view_session)
  if not file_path then
    notify(vim.log.levels.WARN, "Not in a Diffview session")
    return nil
  end

  local current_buf = vim.api.nvim_get_current_buf()
  local side
  if current_buf == view_session.original_bufnr then side = "LEFT"
  elseif current_buf == view_session.modified_bufnr then side = "RIGHT" end
  if not side then
    notify(vim.log.levels.WARN, "Cursor is not in a diff buffer")
    return nil
  end

  local line = vim.fn.line(".")
  return { tabpage = tabpage, file_path = file_path, start_line = line, end_line = line, side = side }
end

local function visual_context()
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then start_line, end_line = end_line, start_line end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)

  local context = current_context()
  if not context then return nil end
  context.start_line = start_line
  context.end_line = end_line
  return context
end

local function get_thread_at_cursor()
  local context = current_context()
  if not context then return nil end
  local s = registry.get(context.tabpage)
  if not s then return nil, {}, context end

  local root
  for _, comment in ipairs(s.comments) do
    if comment.in_reply_to_id == nil
      and comment.path == context.file_path
      and comment.anchor and comment.anchor.side == context.side
      and comment.anchor.line == context.start_line
    then
      root = comment; break
    end
  end
  if not root then return nil, {}, context end

  local replies = {}
  for _, comment in ipairs(s.comments) do
    if comment.in_reply_to_id == root.id then table.insert(replies, comment) end
  end
  table.sort(replies, function(a, b) return tostring(a.id) < tostring(b.id) end)
  return root, replies, context
end

local function ensure_ready()
  local tabpage = vim.api.nvim_get_current_tabpage()
  local provider = registry.provider_for(tabpage)
  local s = registry.get(tabpage)
  if not provider or not s or s.provider ~= provider or not s.pr then
    notify(vim.log.levels.WARN, "No PR data cached. Open Diffview for a PR first.")
    return nil, nil
  end
  return provider, s
end

local function open_comment_popup(title, context, on_submit)
  comments_ui.input({
    title = (" %s: %s:%d-%d (%s) "):format(title, context.file_path,
      context.start_line, context.end_line, context.side),
    on_empty = function() notify(vim.log.levels.WARN, "Empty comment, cancelled") end,
    on_submit = on_submit,
  })
end

local function add_comment(context_fn, pending)
  local provider, s = ensure_ready()
  if not provider then return end

  local context = context_fn()
  if not context then return end
  if not in_diff(context.tabpage, context.file_path, context.start_line, context.end_line, context.side) then
    notify(vim.log.levels.WARN, "Selected lines are outside the diff"); return
  end

  local title = pending and "Pending PR comment" or "PR comment"
  open_comment_popup(title, context, function(body)
    provider.add_comment(s.pr, context, body, { pending = pending }, function(_, err)
      if err then notify(vim.log.levels.ERROR, err); return end
      notify(vim.log.levels.INFO, pending and "Pending comment added" or "Comment posted")
      registry.refresh(context.tabpage, { force = true })
    end)
  end)
end

function M.add_comment_normal(pending)
  add_comment(current_context, pending)
end

function M.add_comment_visual(pending)
  add_comment(visual_context, pending)
end

function M.submit_review(event, label)
  local provider, s = ensure_ready()
  if not provider then return end
  if not provider.submit_review then
    notify(vim.log.levels.WARN, "Submitting reviews is not supported for this provider"); return
  end

  local tabpage = vim.api.nvim_get_current_tabpage()
  comments_ui.input({
    title = (" %s review "):format(label),
    on_empty = function() notify(vim.log.levels.WARN, "Empty review, cancelled") end,
    on_submit = function(body)
      provider.submit_review(s.pr, event, body, function(_, err)
        if err then notify(vim.log.levels.ERROR, err); return end
        notify(vim.log.levels.INFO, ("%s review submitted"):format(label))
        registry.refresh(tabpage, { force = true })
      end)
    end,
  })
end

function M.view_thread()
  local provider, s = ensure_ready()
  if not provider then return end

  local root, replies, context = get_thread_at_cursor()
  if not root then notify(vim.log.levels.WARN, "No PR thread at cursor"); return end

  local thread_comments = { root }
  vim.list_extend(thread_comments, replies)
  comments_ui.open(thread_comments, {
    title = (" Thread: %s:%d (%s) "):format(context.file_path, context.start_line, context.side),
    on_reply = function(_, close)
      close()
      open_comment_popup("Reply", context, function(body)
        provider.reply(s.pr, root, body, function(_, err)
          if err then notify(vim.log.levels.ERROR, err); return end
          notify(vim.log.levels.INFO, "Reply posted")
          registry.refresh(context.tabpage, { force = true })
        end)
      end)
    end,
    on_delete = function(selected, close)
      if not selected then notify(vim.log.levels.WARN, "Move cursor onto a comment first"); return end

      local target = selected.in_reply_to_id and "reply" or "thread"
      vim.ui.input({ prompt = ("Delete %s? [y/N]: "):format(target) }, function(input)
        if type(input) ~= "string" or not input:match("^[yY]") then return end
        provider.delete_comment(s.pr, selected, function(_, err)
          if err then notify(vim.log.levels.ERROR, err); return end
          close()
          notify(vim.log.levels.INFO, selected.in_reply_to_id and "Reply deleted" or "Thread deleted")
          registry.refresh(context.tabpage, { force = true })
        end)
      end)
    end,
  })
end

function M.reload()
  registry.refresh(nil, { force = true })
end

return M
