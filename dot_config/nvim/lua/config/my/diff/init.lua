-- PR comments overlay on Diffview sessions.
-- Orchestrator: per-tabpage SessionState map, async refresh state machine,
-- user commands + keymaps, autocmd wiring. Knows nothing about provider-specific
-- comment shapes — see CONTEXT.md.
if not vim.g.use_pr_comments then
  return
end

local comments_ui = require("config.my.diff.comments_ui")
local sign_plan = require("config.my.diff.sign_plan")
local render = require("config.my.diff.render")
local hunks = require("config.my.diff.hunks")

local providers = {
  require("config.my.diff.providers.bitbucket"),
}

local ns = vim.api.nvim_create_namespace("diff_pr_comments")

---@class SessionState
---@field provider table
---@field session_key string
---@field loading_key string|nil
---@field pr table|nil
---@field comments table[]
---@field diff_files table<string, any>

---@type table<integer, SessionState>
local sessions = {}

local function notify(level, msg)
  vim.notify("[PR comments] " .. tostring(msg), level)
end

local function safe_require(mod)
  -- Diffview submodules reference `DiffviewGlobal` at top level; a pre-bootstrap
  -- require errors and Lua caches the failure sentinel in `package.loaded`.
  if mod:match("^diffview") and not (_G.DiffviewGlobal and _G.DiffviewGlobal.bootstrap_ok) then
    return nil
  end
  local ok, m = pcall(require, mod)
  return ok and m or nil
end

local function rev_to_sha(toplevel, rev)
  if not toplevel or rev == nil or rev == "" then return nil end
  local result = vim.system({ "git", "-C", toplevel, "rev-parse", tostring(rev) }, { text = true }):wait()
  if not result or result.code ~= 0 then return nil end
  return vim.trim(result.stdout)
end

local function bufnr_for(file)
  if not file then return nil end
  local bn = file.bufnr
  if bn and vim.api.nvim_buf_is_valid(bn) then return bn end
  return nil
end

local function current_view_session(tabpage)
  local lib = safe_require("diffview.lib")
  if not lib then return nil end
  local view = tabpage and lib.tabpage_to_view(tabpage) or lib.get_current_view()
  if not view or not view.cur_entry or not view.adapter then return nil end

  local entry = view.cur_entry
  local layout = entry.layout
  if not layout or not layout.a or not layout.b then return nil end

  local toplevel = view.adapter.ctx and view.adapter.ctx.toplevel or nil
  local right = view.right or {}
  local left = view.left or {}

  local modified_revision = right.commit
  if (not modified_revision or modified_revision == "") and right.type then
    modified_revision = ""
  end
  if modified_revision and modified_revision ~= "" and not modified_revision:match("^[0-9a-f]+$") then
    modified_revision = rev_to_sha(toplevel, modified_revision) or modified_revision
  end

  return {
    git_root = toplevel,
    modified_revision = modified_revision or "",
    original_revision = left.commit or "",
    modified_path = entry.path,
    original_path = entry.oldpath ~= "" and entry.oldpath or entry.path,
    modified_bufnr = bufnr_for(layout.b.file),
    original_bufnr = bufnr_for(layout.a.file),
  }
end

local function has_revision(view_session)
  if not view_session then return false end
  local rev = tostring(view_session.modified_revision or "")
  return rev ~= "" and rev ~= "WORKING" and rev ~= "STAGED"
end

local function build_session_key(view_session, provider_name)
  if not has_revision(view_session) then return nil end
  local root = tostring(view_session.git_root or "")
  if root == "" then return nil end
  return table.concat({ provider_name or "", root, tostring(view_session.modified_revision) }, ":")
end

local function provider_for(tabpage)
  local view_session = current_view_session(tabpage)
  if not view_session then return nil, nil end
  for _, mod in ipairs(providers) do
    if mod.can_handle and mod.can_handle(view_session) then
      return mod, view_session
    end
  end
  return nil, view_session
end

local function tabpage_from_event(event)
  return event and event.data and event.data.tabpage or vim.api.nvim_get_current_tabpage()
end

local function rel_file_path(view_session)
  local file_path = (view_session.original_path ~= "" and view_session.original_path)
    or (view_session.modified_path ~= "" and view_session.modified_path)
  if not file_path then return nil end

  local root = tostring(view_session.git_root or "")
  if root ~= "" then
    local prefix = root .. "/"
    if file_path:sub(1, #prefix) == prefix then
      file_path = file_path:sub(#prefix + 1)
    end
  end
  return file_path
end

local function show(tabpage)
  local s = sessions[tabpage]
  if not s or not s.pr then return end

  local view_session = current_view_session(tabpage)
  if not view_session then return end
  local file_path = rel_file_path(view_session)
  if not file_path then return end

  local sides = {
    { side = "LEFT",  bufnr = view_session.original_bufnr },
    { side = "RIGHT", bufnr = view_session.modified_bufnr },
  }
  for _, sb in ipairs(sides) do
    if sb.bufnr then
      local line_count = vim.api.nvim_buf_line_count(sb.bufnr)
      local plan = sign_plan.plan(s.comments, file_path, sb.side, line_count)
      render.apply(sb.bufnr, ns, plan)
    end
  end
end

local function destroy_session(tabpage)
  local s = sessions[tabpage]
  if not s then return end
  -- Best-effort: clear the render memo for the buffers we last saw. The view's
  -- buffers may already be invalid if the tab is closing; render.clear_memo is
  -- a plain table delete and tolerates that.
  local view_session = current_view_session(tabpage)
  if view_session then
    if view_session.original_bufnr then render.clear_memo(view_session.original_bufnr) end
    if view_session.modified_bufnr then render.clear_memo(view_session.modified_bufnr) end
  end
  sessions[tabpage] = nil
end

local function refresh(tabpage, opts)
  opts = opts or {}
  tabpage = tabpage or vim.api.nvim_get_current_tabpage()
  local provider, view_session = provider_for(tabpage)
  if not provider or not has_revision(view_session) then return end

  local key = build_session_key(view_session, provider.name)
  local s = sessions[tabpage]
  if opts.force ~= true and s and key and s.session_key == key and s.pr then
    show(tabpage)
    return
  end
  if s and key and s.loading_key == key then return end

  s = {
    provider = provider,
    session_key = key,
    loading_key = key,
    pr = nil,
    comments = {},
    diff_files = {},
  }
  sessions[tabpage] = s
  notify(vim.log.levels.INFO, "Loading PR comments...")

  provider.find_pr(view_session, function(pr, pr_err)
    if sessions[tabpage] ~= s or s.loading_key ~= key then return end
    if pr_err then s.loading_key = nil; notify(vim.log.levels.WARN, pr_err); return end
    if not pr then s.loading_key = nil; notify(vim.log.levels.WARN, "No PR found"); return end

    s.pr = pr
    local loaded = { diff = false, comments = false }

    local function finish()
      if not loaded.diff or not loaded.comments then return end
      s.loading_key = nil
      show(tabpage)
      notify(vim.log.levels.INFO, ("Loaded %d PR comments"):format(#s.comments))
    end

    provider.fetch_diff_files(pr, function(files)
      if sessions[tabpage] == s and s.session_key == key then
        s.diff_files = files or {}
        loaded.diff = true
        finish()
      end
    end)

    provider.fetch_comments(pr, function(comments, comments_err)
      if comments_err then
        s.loading_key = nil; s.pr = nil; s.session_key = nil
        notify(vim.log.levels.WARN, comments_err); return
      end
      if sessions[tabpage] ~= s or s.session_key ~= key then return end
      s.comments = comments or {}
      loaded.comments = true
      finish()
    end)
  end)
end

local function in_diff(tabpage, file_path, start_line, end_line, side)
  local s = sessions[tabpage]
  if not s then return false end
  local file = s.diff_files[file_path]
  if not file then return false end
  return hunks.contains(hunks.parse(file), start_line, end_line, side)
end

local function current_context()
  local tabpage = vim.api.nvim_get_current_tabpage()
  local view_session = current_view_session(tabpage)
  if not view_session then
    notify(vim.log.levels.WARN, "Not in a Diffview session")
    return nil
  end
  local file_path = rel_file_path(view_session)
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
  local s = sessions[context.tabpage]
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
  local provider = provider_for(tabpage)
  local s = sessions[tabpage]
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
      refresh(context.tabpage, { force = true })
    end)
  end)
end

local function submit_review(event, label)
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
        refresh(tabpage, { force = true })
      end)
    end,
  })
end

local function view_thread()
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
          refresh(context.tabpage, { force = true })
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
          refresh(context.tabpage, { force = true })
        end)
      end)
    end,
  })
end

vim.keymap.set("v", "<leader>occ", function() add_comment(visual_context, true) end, { desc = "Add pending PR comment" })
vim.keymap.set("n", "<leader>occ", function() add_comment(current_context, true) end, { desc = "Add pending PR comment" })
vim.keymap.set("v", "<leader>ocC", function() add_comment(visual_context, false) end, { desc = "Add PR comment" })
vim.keymap.set("n", "<leader>ocC", function() add_comment(current_context, false) end, { desc = "Add PR comment" })
vim.keymap.set("n", "<leader>ocv", view_thread, { desc = "View PR thread" })
vim.keymap.set("n", "<leader>oca", function() submit_review("APPROVE", "Approve") end, { desc = "Approve PR review" })
vim.keymap.set("n", "<leader>ocr", function() submit_review("REQUEST_CHANGES", "Request changes") end, { desc = "Request PR changes" })
vim.keymap.set("n", "<leader>ocR", function() refresh(nil, { force = true }) end, { desc = "Reload PR comments" })

local group = vim.api.nvim_create_augroup("my_diff_comments", { clear = true })

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "DiffviewViewOpened",
  callback = function(event)
    vim.schedule(function() refresh(tabpage_from_event(event)) end)
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "DiffviewDiffBufRead",
  callback = function(event)
    local tabpage = tabpage_from_event(event)
    vim.schedule(function() show(tabpage) end)
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "DiffviewDiffBufWinEnter",
  callback = function(event)
    local tabpage = tabpage_from_event(event)
    vim.schedule(function()
      refresh(tabpage)
      vim.defer_fn(function() show(tabpage) end, 50)
    end)
  end,
})

vim.api.nvim_create_autocmd("WinEnter", {
  group = group,
  callback = function()
    local tabpage = vim.api.nvim_get_current_tabpage()
    vim.schedule(function() show(tabpage) end)
  end,
})

vim.api.nvim_create_autocmd("TabClosed", {
  group = group,
  callback = function(event)
    local tab = tonumber(event.match)
    if tab then destroy_session(tab) end
  end,
})

return {
  __sessions = sessions,
}
