-- PR comments quickfix browser for the working tree.
--
-- Fetches comments for the current branch's PR from whichever provider
-- claims the origin URL, populates the quickfix list with one entry per
-- thread root, and asks the sign painter to render signs in the signcolumn
-- of any open buffer whose path matches a thread.
--
-- Inside the qf list:
--   * cursor on entry → thread renders inline as `virt_lines` extmarks below
--     the entry, code window auto-previews the entry's file:line (cursor stays
--     in qf)
--   * `r`/`d`/`e` → reply / delete-thread / edit-root, scoped to the entry's
--     thread root
--   * `K`            → floating popup with full per-comment r/d/e (the old
--     popup, kept for fine-grained edits on individual replies)
--   * `<CR>`         → jump focus to the previewed code window
--
-- In a code buffer with PR threads loaded, `K` peeks the thread under cursor
-- (or falls through to `vim.lsp.buf.hover()` when the cursor is off-thread).
-- Inter-thread navigation uses the user's existing `]q`/`[q` (`:cnext` /
-- `:cprev`).
local M = {}

local registry = require("config.my.diff.registry")
local sign_painter = require("config.my.diff.sign_painter")
local comments_ui = require("config.my.diff.comments_ui")

local QF_TITLE = "PR Comments"
local virt_ns = vim.api.nvim_create_namespace("pr_comments_qf_virt")

---@type { root: string, pr: table, provider: table, threads_by_path: table<string, table[]>, current_user: table|nil }|nil
local state
local active_popup
-- Tracks the extmark currently providing virt_lines under a qf entry so
-- CursorMoved can clear it before drawing a new one.
local active_virt = { bufnr = nil, id = nil }

local function notify(level, msg)
  vim.notify("[PR comments] " .. tostring(msg), level)
end

local function trim(value)
  if type(value) ~= "string" then return "" end
  return vim.trim(value)
end

local function git_root()
  local result = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true }):wait()
  if not result or result.code ~= 0 then return nil end
  local root = trim(result.stdout)
  return root ~= "" and root or nil
end

local function current_branch(root)
  local result = vim.system({ "git", "-C", root, "rev-parse", "--abbrev-ref", "HEAD" }, { text = true }):wait()
  if not result or result.code ~= 0 then return nil end
  local branch = trim(result.stdout)
  return branch ~= "" and branch or nil
end

local function origin_url(root)
  local result = vim.system({ "git", "-C", root, "remote", "get-url", "origin" }, { text = true }):wait()
  if not result or result.code ~= 0 then return nil end
  local url = trim(result.stdout)
  return url ~= "" and url or nil
end

local function range_from_comment(comment)
  if comment.range and comment.range.start_line and comment.range.end_line then
    return { start_line = comment.range.start_line, end_line = comment.range.end_line }
  end
  if comment.anchor and comment.anchor.line then
    return { start_line = comment.anchor.line, end_line = comment.anchor.line }
  end
  return nil
end

local function build_threads(comments)
  local roots = {}
  local replies_by_root = {}
  for _, c in ipairs(comments) do
    if not c.in_reply_to_id and c.path and c.anchor then
      table.insert(roots, c)
      replies_by_root[c.id] = {}
    end
  end
  for _, c in ipairs(comments) do
    if c.in_reply_to_id and replies_by_root[c.in_reply_to_id] then
      table.insert(replies_by_root[c.in_reply_to_id], c)
    end
  end
  for _, replies in pairs(replies_by_root) do
    table.sort(replies, function(a, b) return tostring(a.id) < tostring(b.id) end)
  end
  return roots, replies_by_root
end

local function first_line(body)
  if type(body) ~= "string" then return "" end
  for line in body:gmatch("[^\r\n]+") do return line end
  return ""
end

local function group_by_path(roots, replies_by_root)
  local out = {}
  for _, c in ipairs(roots) do
    out[c.path] = out[c.path] or {}
    local range = range_from_comment(c)
    if range then
      table.insert(out[c.path], {
        root = c,
        replies = replies_by_root[c.id] or {},
        range = range,
        line = c.anchor.line,
      })
    end
  end
  for _, threads in pairs(out) do
    table.sort(threads, function(a, b) return a.line < b.line end)
  end
  return out
end

local function is_mine(comment)
  if not state or not state.current_user then return false end
  if comment.user_id and state.current_user.id and comment.user_id == state.current_user.id then
    return true
  end
  if comment.user and state.current_user.username
    and comment.user == state.current_user.username then
    return true
  end
  return false
end

-- ---------------------------------------------------------------------------
-- Floating popup ("K" / CodeDiff view_thread)
-- ---------------------------------------------------------------------------

local function show_popup_for_thread(thread, opts)
  opts = opts or {}
  local thread_comments = { thread.root }
  vim.list_extend(thread_comments, thread.replies or {})

  if active_popup and active_popup.win and vim.api.nvim_win_is_valid(active_popup.win) then
    active_popup.close()
    active_popup = nil
  end

  vim.schedule(function()
    local handle = comments_ui.open(thread_comments, {
      title = opts.title or (" Thread: %s:%d "):format(thread.root.path or "?", thread.root.anchor.line),
      relative_to_cursor = opts.relative_to_cursor,
      is_mine = is_mine,
      on_close = function() active_popup = nil end,
      on_reply = function(_, close)
        close()
        M._reply_to(thread)
      end,
      on_edit = function(comment, close)
        close()
        M._edit(comment)
      end,
      on_delete = function(comment, close)
        M._delete(comment, close)
      end,
    })
    active_popup = handle
  end)
end

-- ---------------------------------------------------------------------------
-- Quickfix: virt_lines + auto-preview
-- ---------------------------------------------------------------------------

local function clear_virt()
  if active_virt.bufnr and vim.api.nvim_buf_is_valid(active_virt.bufnr) and active_virt.id then
    pcall(vim.api.nvim_buf_del_extmark, active_virt.bufnr, virt_ns, active_virt.id)
  end
  active_virt = { bufnr = nil, id = nil }
end

local function render_virt_for_entry(qf_bufnr, lnum, thread)
  clear_virt()
  if not vim.api.nvim_buf_is_valid(qf_bufnr) or not thread then return end
  local thread_comments = { thread.root }
  vim.list_extend(thread_comments, thread.replies or {})
  local virt_lines = comments_ui.thread_virt_lines(thread_comments, { width = vim.o.columns - 4 })
  if #virt_lines == 0 then return end
  local id = vim.api.nvim_buf_set_extmark(qf_bufnr, virt_ns, lnum - 1, 0, {
    virt_lines = virt_lines,
    virt_lines_above = false,
  })
  active_virt = { bufnr = qf_bufnr, id = id }
end

-- Returns the first non-qf, normal-buftype window in the same tabpage as
-- `qf_winid`, or nil if none exists.
local function preview_target_window(qf_winid)
  local tabpage = vim.api.nvim_win_get_tabpage(qf_winid)
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
    if w ~= qf_winid then
      local b = vim.api.nvim_win_get_buf(w)
      if vim.bo[b].buftype == "" then return w end
    end
  end
  return nil
end

local function preview_entry(qf_winid, item)
  if not item or not item.filename or item.filename == "" then return end
  local target = preview_target_window(qf_winid)
  if not target then return end
  local fname = vim.fn.fnamemodify(item.filename, ":p")
  local bufnr = vim.fn.bufnr(fname, true)
  if bufnr <= 0 then return end
  vim.fn.bufload(bufnr)
  if vim.api.nvim_win_get_buf(target) ~= bufnr then
    vim.api.nvim_win_set_buf(target, bufnr)
  end
  if item.lnum and item.lnum > 0 then
    pcall(vim.api.nvim_win_set_cursor, target, { item.lnum, 0 })
    vim.api.nvim_win_call(target, function() vim.cmd("normal! zz") end)
  end
end

local function find_qf_win()
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    local b = vim.api.nvim_win_get_buf(w)
    if vim.bo[b].buftype == "quickfix" then return w, b end
  end
  return nil, nil
end

-- Re-render virt_lines + auto-preview the entry at line `lnum` in the qf buffer.
-- Cursor stays where it is — never switches focus.
local function sync_to_entry(qf_winid, qf_bufnr, lnum)
  local list = vim.fn.getqflist({ title = 0, items = 0 })
  if list.title ~= QF_TITLE then return end
  local item = list.items[lnum]
  if not item then clear_virt(); return end
  if item.user_data and type(item.user_data) == "table" and item.user_data.thread then
    render_virt_for_entry(qf_bufnr, lnum, item.user_data.thread)
  else
    clear_virt()
  end
  preview_entry(qf_winid, item)
end

-- ---------------------------------------------------------------------------
-- Per-entry actions inside the qf buffer
-- ---------------------------------------------------------------------------

local function entry_thread_at_cursor()
  local list = vim.fn.getqflist({ title = 0, items = 0 })
  if list.title ~= QF_TITLE then return nil end
  local item = list.items[vim.fn.line(".")]
  if not (item and item.user_data and type(item.user_data) == "table") then return nil end
  return item.user_data.thread
end

local function bind_qf_buffer(qf_winid)
  if not qf_winid or not vim.api.nvim_win_is_valid(qf_winid) then return end
  local qf_bufnr = vim.api.nvim_win_get_buf(qf_winid)
  local opts = { buffer = qf_bufnr, silent = true }

  vim.keymap.set("n", "<CR>", function()
    local target = preview_target_window(qf_winid)
    if not target then
      pcall(vim.cmd, "cc " .. vim.fn.line("."))
      return
    end
    sync_to_entry(qf_winid, qf_bufnr, vim.fn.line("."))
    vim.api.nvim_set_current_win(target)
  end, vim.tbl_extend("force", opts, { desc = "Jump to previewed code" }))

  vim.keymap.set("n", "K", function()
    local t = entry_thread_at_cursor()
    if not t then return end
    show_popup_for_thread(t)
  end, vim.tbl_extend("force", opts, { desc = "Peek thread (full per-comment actions)" }))

  vim.keymap.set("n", "r", function()
    local t = entry_thread_at_cursor()
    if t then M._reply_to(t) end
  end, vim.tbl_extend("force", opts, { desc = "Reply to thread root" }))

  vim.keymap.set("n", "d", function()
    local t = entry_thread_at_cursor()
    if not t then return end
    M._delete(t.root, nil, t.root.id)
  end, vim.tbl_extend("force", opts, { desc = "Delete thread" }))

  vim.keymap.set("n", "e", function()
    local t = entry_thread_at_cursor()
    if not t then return end
    if not is_mine(t.root) then notify(vim.log.levels.WARN, "Can only edit your own comments"); return end
    M._edit(t.root)
  end, vim.tbl_extend("force", opts, { desc = "Edit thread root" }))

  -- Auto-preview + virt_lines on cursor moves inside the qf buffer.
  -- Named group with `clear = true` so repeated `<leader>oc` doesn't stack
  -- duplicate handlers (each cursor move would otherwise fire N preview swaps).
  local cursor_group = vim.api.nvim_create_augroup("pr_comments_qf_cursor", { clear = true })
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = cursor_group,
    buffer = qf_bufnr,
    callback = function()
      sync_to_entry(qf_winid, qf_bufnr, vim.fn.line("."))
    end,
  })
end

-- ---------------------------------------------------------------------------
-- Code-buffer K (peek-or-hover) binding
-- ---------------------------------------------------------------------------

local function thread_for_line(threads, line)
  for _, t in ipairs(threads) do
    if t.range.start_line <= line and line <= t.range.end_line then return t end
  end
  return nil
end

local function bind_buffer(bufnr)
  vim.keymap.set("n", "K", function()
    if vim.bo[bufnr].buftype ~= "" then return vim.lsp.buf.hover() end
    local threads = sign_painter.threads_for_buffer(bufnr)
    if not threads then return vim.lsp.buf.hover() end
    local thread = thread_for_line(threads, vim.fn.line("."))
    if thread then
      show_popup_for_thread(thread, { relative_to_cursor = true })
    else
      vim.lsp.buf.hover()
    end
  end, { buffer = bufnr, silent = true, desc = "Peek PR thread / LSP hover" })
end

local function unbind_buffer(bufnr)
  pcall(vim.keymap.del, "n", "K", { buffer = bufnr })
end

local function refresh_keymaps()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      if state and sign_painter.threads_for_buffer(bufnr) then
        bind_buffer(bufnr)
      else
        unbind_buffer(bufnr)
      end
    end
  end
end

local function setup_autocmds()
  local group = vim.api.nvim_create_augroup("pr_comments_qf", { clear = true })

  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = group,
    callback = function(args)
      if vim.bo[args.buf].buftype ~= "" then return end
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(args.buf) then return end
        if not state then return end
        sign_painter.refresh_buffer(args.buf)
        if sign_painter.threads_for_buffer(args.buf) then
          bind_buffer(args.buf)
        end
      end)
    end,
  })
end

-- ---------------------------------------------------------------------------
-- Quickfix list + load orchestration
-- ---------------------------------------------------------------------------

local function populate_qf(roots, replies_by_root, root_path)
  -- Most-recent first. Falls back to id when timestamps are missing or equal
  -- so order stays deterministic even on payloads without created_at.
  local sorted = vim.list_extend({}, roots)
  table.sort(sorted, function(a, b)
    local ta, tb = a.created_at or "", b.created_at or ""
    if ta ~= tb then return ta > tb end
    return tostring(a.id) > tostring(b.id)
  end)

  local items = {}
  for _, c in ipairs(sorted) do
    local replies = replies_by_root[c.id] or {}
    local range = range_from_comment(c) or { start_line = c.anchor.line, end_line = c.anchor.line }
    table.insert(items, {
      filename = root_path .. "/" .. c.path,
      lnum = c.anchor.line,
      text = ("@%s: %s"):format(c.user or "?", first_line(c.body)),
      user_data = {
        path = c.path,
        range = range,
        thread = { root = c, replies = replies },
      },
    })
  end
  vim.fn.setqflist({}, " ", { title = QF_TITLE, items = items })
  return #items
end

---@param on_done fun(success: boolean)
local function load(on_done)
  on_done = on_done or function() end
  local root = git_root()
  if not root then notify(vim.log.levels.WARN, "Not in a git repository"); on_done(false); return end

  local url = origin_url(root)
  if not url then notify(vim.log.levels.WARN, "No origin remote"); on_done(false); return end

  local provider, workspace, repo = registry.provider_for_origin_url(url)
  if not provider then
    notify(vim.log.levels.WARN, "No PR provider claims this remote"); on_done(false); return
  end

  local branch = current_branch(root)
  if not branch then notify(vim.log.levels.WARN, "Could not resolve current branch"); on_done(false); return end

  local user_done, prs_done = false, false
  local current_user, pr, comments_normalized

  local function maybe_finish()
    if not (user_done and prs_done) then return end
    if not pr then on_done(false); return end

    local roots, replies_by_root = build_threads(comments_normalized or {})
    local threads_by_path = group_by_path(roots, replies_by_root)
    state = {
      root = root,
      pr = pr,
      provider = provider,
      threads_by_path = threads_by_path,
      current_user = current_user,
    }
    sign_painter.set_state({ root = root, threads_by_path = threads_by_path })
    refresh_keymaps()
    populate_qf(roots, replies_by_root, root)
    on_done(true)
  end

  if provider.fetch_current_user then
    provider.fetch_current_user(function(user, err)
      if err then notify(vim.log.levels.DEBUG, "current user: " .. err) end
      current_user = user
      user_done = true
      maybe_finish()
    end)
  else
    user_done = true
  end

  notify(vim.log.levels.INFO, ("Loading PR comments for %s..."):format(branch))
  provider.find_pr_for_branch(workspace, repo, branch, function(found_pr, err)
    if err then notify(vim.log.levels.WARN, err); prs_done = true; maybe_finish(); return end
    if not found_pr then
      notify(vim.log.levels.WARN, "No open PR for branch " .. branch)
      prs_done = true; maybe_finish(); return
    end
    pr = found_pr

    provider.fetch_comments(pr, function(values, err2)
      if err2 then notify(vim.log.levels.WARN, err2); pr = nil; prs_done = true; maybe_finish(); return end
      comments_normalized = values or {}
      prs_done = true
      maybe_finish()
    end)
  end)
end

-- After mutation, re-load + restore qf cursor onto the same root id (so the
-- user keeps their place across reply/edit). For deletes, `preserve_root_id`
-- is the *deleted* id — we fall through to the same line index, which now
-- points at the next thread (entries shifted up by one).
local function refresh_after_mutation(preserve_root_id, fallback_idx)
  load(function(success)
    if not success or not state then return end
    local list = vim.fn.getqflist({ title = 0, items = 0 })
    if list.title ~= QF_TITLE then return end

    local target_idx
    if preserve_root_id then
      for i, item in ipairs(list.items) do
        if item.user_data and item.user_data.thread
          and item.user_data.thread.root.id == preserve_root_id then
          target_idx = i; break
        end
      end
    end
    if not target_idx and fallback_idx then
      target_idx = math.max(1, math.min(fallback_idx, #list.items))
    end

    local qf_winid, qf_bufnr = find_qf_win()
    if qf_winid and qf_bufnr and target_idx and target_idx > 0 then
      pcall(vim.api.nvim_win_set_cursor, qf_winid, { target_idx, 0 })
      sync_to_entry(qf_winid, qf_bufnr, target_idx)
    end
  end)
end

-- Tear down everything `<leader>oc` set up: state, signs, code-buffer K
-- bindings, virt_lines, popup, and the PR Comments qf list itself. Leaves
-- other quickfix lists untouched (only acts if the current list's title is
-- `PR Comments`).
function M.close()
  state = nil
  clear_virt()
  if active_popup and active_popup.win and vim.api.nvim_win_is_valid(active_popup.win) then
    active_popup.close()
  end
  active_popup = nil
  sign_painter.set_state(nil)
  refresh_keymaps()
  pcall(vim.api.nvim_clear_autocmds, { group = "pr_comments_qf_cursor" })
  local list = vim.fn.getqflist({ title = 0 })
  if list.title == QF_TITLE then
    vim.fn.setqflist({}, "r", { title = QF_TITLE, items = {} })
    vim.cmd("silent! cclose")
  end
  notify(vim.log.levels.INFO, "Cleared PR comments")
end

function M.open()
  load(function(success)
    if not success or not state then return end
    local thread_count = 0
    for _, ts in pairs(state.threads_by_path) do thread_count = thread_count + #ts end
    if thread_count == 0 then notify(vim.log.levels.INFO, "No PR comments"); return end
    vim.cmd("copen")
    local qf_winid = vim.api.nvim_get_current_win()
    local qf_bufnr = vim.api.nvim_win_get_buf(qf_winid)
    bind_qf_buffer(qf_winid)
    -- Initial expand + preview for entry 1.
    sync_to_entry(qf_winid, qf_bufnr, 1)
    notify(vim.log.levels.INFO, ("Loaded %d threads"):format(thread_count))
  end)
end

function M._edit(comment)
  if not state or not state.pr or not state.provider then return end
  local provider = state.provider
  if not provider.edit_comment then
    notify(vim.log.levels.WARN, "Edit not supported"); return
  end

  -- Preserve cursor on this comment's *thread* — use the root id when the
  -- comment is a root, otherwise its parent (which we don't track on the
  -- comment itself; falling back to `id` covers the common in-qf case where
  -- only roots are edited).
  local preserve_id = comment.in_reply_to_id or comment.id

  comments_ui.input({
    title = " Edit PR comment ",
    initial_body = comment.body or "",
    on_empty = function() notify(vim.log.levels.WARN, "Empty comment, cancelled") end,
    on_submit = function(body)
      provider.edit_comment(state.pr, comment, body, function(_, err)
        if err then notify(vim.log.levels.ERROR, err); return end
        notify(vim.log.levels.INFO, "Comment updated")
        refresh_after_mutation(preserve_id)
      end)
    end,
  })
end

function M._delete(comment, close, preserve_root_id)
  if not state or not state.pr or not state.provider then return end
  local provider = state.provider
  if not provider.delete_comment then return end

  local target = comment.in_reply_to_id and "reply" or "thread"
  local fallback_idx
  local qf_winid = find_qf_win()
  if qf_winid then
    fallback_idx = vim.api.nvim_win_get_cursor(qf_winid)[1]
  end

  vim.ui.input({ prompt = ("Delete %s? [y/N]: "):format(target) }, function(input)
    if type(input) ~= "string" or not input:match("^[yY]") then return end
    if close then close() end
    provider.delete_comment(state.pr, comment, function(_, err)
      if err then notify(vim.log.levels.ERROR, err); return end
      notify(vim.log.levels.INFO, target == "reply" and "Reply deleted" or "Thread deleted")
      -- For thread delete, the root is gone — preserve_root_id won't match;
      -- refresh_after_mutation falls back to the same idx (next entry shifts up).
      refresh_after_mutation(preserve_root_id or comment.in_reply_to_id, fallback_idx)
    end)
  end)
end

function M._reply_to(thread)
  if not state or not state.pr or not state.provider then return end
  local provider = state.provider
  if not provider.reply then return end

  local preserve_id = thread.root.id

  comments_ui.input({
    title = (" Reply: %s:%d "):format(thread.root.path or "?", thread.root.anchor.line),
    on_empty = function() notify(vim.log.levels.WARN, "Empty reply, cancelled") end,
    on_submit = function(body)
      provider.reply(state.pr, thread.root, body, function(_, err)
        if err then notify(vim.log.levels.ERROR, err); return end
        notify(vim.log.levels.INFO, "Reply posted")
        refresh_after_mutation(preserve_id)
      end)
    end,
  })
end

setup_autocmds()
sign_painter.setup_highlights()

return M
