-- PR comments quickfix browser + sign-column overlay for the working tree.
-- Fetches comments for the current branch's PR (Bitbucket only), populates the
-- quickfix list with one entry per thread root, and paints signs in the
-- signcolumn of any open buffer whose path matches a thread. Tab / S-Tab cycle
-- between threads in the current buffer; <leader>oct toggles the overlay.
local M = {}

local atlas_client_mod = require("config.my.diff.providers.atlas_client")
local bitbucket = require("config.my.diff.providers.bitbucket")
local links = require("config.my.diff.providers.bitbucket_links")
local comments_ui = require("config.my.diff.comments_ui")

local QF_TITLE = "PR Comments"
local SIGN_HL = "PRCommentSign"
local SIGN_PENDING_HL = "PRCommentSignPending"
local SIGN_ICON = "▌"

local hl_ns = vim.api.nvim_create_namespace("pr_comments_qf_highlight")
local sign_ns = vim.api.nvim_create_namespace("pr_comments_signs")

---@type { root: string, pr: table, threads_by_path: table<string, table[]>, current_user: table|nil }|nil
local state
local last_shown_idx
local active_highlight
local active_popup

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

local function parse_origin(root)
  local result = vim.system({ "git", "-C", root, "remote", "get-url", "origin" }, { text = true }):wait()
  if not result or result.code ~= 0 then return nil end
  local url = trim(result.stdout)
  if not url:find("bitbucket", 1, false) then return nil end
  local path = url:match("^[%w_-]+@[^:]+:(.+)$")
    or url:match("^https?://[^/]+/(.+)$")
    or url:match("^[%w]+://[^/]+/(.+)$")
  if not path then return nil end
  path = path:gsub("%.git$", "")
  local workspace, repo = path:match("^([^/]+)/(.+)$")
  return workspace, repo
end

local function setup_highlights()
  if vim.fn.hlexists(SIGN_HL) == 0 then
    vim.api.nvim_set_hl(0, SIGN_HL, { fg = "#c6a0f6", bold = true })
  end
  if vim.fn.hlexists(SIGN_PENDING_HL) == 0 then
    vim.api.nvim_set_hl(0, SIGN_PENDING_HL, { fg = "#f5a97f", bold = true })
  end
end

local function range_from_raw(comment)
  local raw = comment._raw or {}
  local inline = raw.inline or {}
  local end_line = tonumber(inline.to) or tonumber(inline["from"])
  if not end_line then
    if comment.anchor and comment.anchor.line then
      return { start_line = comment.anchor.line, end_line = comment.anchor.line }
    end
    return nil
  end
  local start_line = tonumber(inline.start_to) or tonumber(inline.start_from) or end_line
  if start_line > end_line then start_line, end_line = end_line, start_line end
  return { start_line = start_line, end_line = end_line }
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
    local range = range_from_raw(c) or { start_line = c.anchor.line, end_line = c.anchor.line }
    table.insert(out[c.path], {
      root = c,
      replies = replies_by_root[c.id] or {},
      range = range,
      line = c.anchor.line,
    })
  end
  for _, threads in pairs(out) do
    table.sort(threads, function(a, b) return a.line < b.line end)
  end
  return out
end

local function clear_active_highlight()
  if not active_highlight then return end
  if vim.api.nvim_buf_is_valid(active_highlight.bufnr) then
    vim.api.nvim_buf_clear_namespace(active_highlight.bufnr, hl_ns, 0, -1)
  end
  active_highlight = nil
end

local function highlight_range(bufnr, range)
  clear_active_highlight()
  if not range or not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then return end
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  for line = range.start_line, math.min(range.end_line, line_count) do
    vim.api.nvim_buf_set_extmark(bufnr, hl_ns, line - 1, 0, {
      end_row = line,
      end_col = 0,
      hl_eol = true,
      hl_group = "Visual",
      priority = 200,
    })
  end
  active_highlight = { bufnr = bufnr }
end

local function buf_relative_path(bufnr)
  if not state then return nil end
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then return nil end
  local abs = vim.fn.fnamemodify(name, ":p")
  local root = state.root
  if abs:sub(1, #root + 1) == root .. "/" then
    return abs:sub(#root + 2)
  end
  return nil
end

local function clear_signs(bufnr)
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_clear_namespace(bufnr, sign_ns, 0, -1)
  end
end

local function render_signs(bufnr)
  if not state then return end
  if not vim.api.nvim_buf_is_valid(bufnr) then return end
  if vim.bo[bufnr].buftype ~= "" then return end

  local rel = buf_relative_path(bufnr)
  if not rel then return end
  local threads = state.threads_by_path[rel]
  if not threads then return end

  vim.api.nvim_buf_clear_namespace(bufnr, sign_ns, 0, -1)
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  for _, t in ipairs(threads) do
    local pending = t.root.pending == true
    local hl = pending and SIGN_PENDING_HL or SIGN_HL
    for line_num = t.range.start_line, t.range.end_line do
      if line_num >= 1 and line_num <= line_count then
        vim.api.nvim_buf_set_extmark(bufnr, sign_ns, line_num - 1, 0, {
          sign_text = SIGN_ICON,
          sign_hl_group = hl,
          priority = 100,
        })
      end
    end
  end
end

local function show_thread(bufnr, thread)
  local rel = buf_relative_path(bufnr)
  if not rel then return end

  pcall(vim.api.nvim_win_set_cursor, 0, { thread.range.start_line, 0 })
  highlight_range(bufnr, thread.range)

  local thread_comments = { thread.root }
  vim.list_extend(thread_comments, thread.replies or {})

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

  if active_popup and active_popup.win and vim.api.nvim_win_is_valid(active_popup.win) then
    active_popup.close()
    active_popup = nil
  end

  vim.schedule(function()
    local handle = comments_ui.open(thread_comments, {
      title = (" Thread: %s:%d "):format(rel, thread.range.start_line),
      relative_to_cursor = true,
      is_mine = is_mine,
      on_close = function()
        clear_active_highlight()
        active_popup = nil
      end,
      on_reply = function(_, close)
        close()
        require("config.my.diff.qf")._reply_to(thread)
      end,
      on_edit = function(comment, close)
        close()
        require("config.my.diff.qf")._edit(comment)
      end,
      on_delete = function(comment, close)
        require("config.my.diff.qf")._delete(comment, close)
      end,
    })
    active_popup = handle
  end)
end

local function thread_for_line(threads, line)
  for _, t in ipairs(threads) do
    if t.range.start_line <= line and line <= t.range.end_line then return t end
  end
  return nil
end

local function next_thread(threads, line, dir)
  if dir > 0 then
    for _, t in ipairs(threads) do
      if t.line > line then return t end
    end
    return threads[1]
  else
    for i = #threads, 1, -1 do
      if threads[i].line < line then return threads[i] end
    end
    return threads[#threads]
  end
end

local function jump(dir)
  if not state then notify(vim.log.levels.WARN, "No PR comments loaded"); return end
  local bufnr = vim.api.nvim_get_current_buf()
  local rel = buf_relative_path(bufnr)
  if not rel then notify(vim.log.levels.WARN, "Buffer not in PR"); return end
  local threads = state.threads_by_path[rel]
  if not threads or #threads == 0 then notify(vim.log.levels.WARN, "No threads in this file"); return end

  local cur_line = vim.fn.line(".")
  local target = next_thread(threads, cur_line, dir)
  if not target then return end
  show_thread(bufnr, target)
end

local function bind_buffer(bufnr)
  vim.keymap.set("n", "<Tab>", function() jump(1) end, {
    buffer = bufnr, silent = true, desc = "Next PR comment thread",
  })
  vim.keymap.set("n", "<S-Tab>", function() jump(-1) end, {
    buffer = bufnr, silent = true, desc = "Previous PR comment thread",
  })
end

local function unbind_buffer(bufnr)
  pcall(vim.keymap.del, "n", "<Tab>", { buffer = bufnr })
  pcall(vim.keymap.del, "n", "<S-Tab>", { buffer = bufnr })
end

local function refresh_all_buffers()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      clear_signs(bufnr)
      if state then
        local rel = buf_relative_path(bufnr)
        if rel and state.threads_by_path[rel] then
          render_signs(bufnr)
          bind_buffer(bufnr)
        else
          unbind_buffer(bufnr)
        end
      else
        unbind_buffer(bufnr)
      end
    end
  end
end

local function show_thread_for_current_qf_entry()
  local qf = vim.fn.getqflist({ title = 0, idx = 0, items = 0 })
  if qf.title ~= QF_TITLE then return end
  local idx = qf.idx
  if idx == 0 or idx == last_shown_idx then return end
  local item = qf.items[idx]
  if not item or not item.user_data or type(item.user_data) ~= "table" then return end
  local data = item.user_data
  if not data.thread or not state then return end
  last_shown_idx = idx

  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].buftype ~= "" then return end

  local thread
  local threads = state.threads_by_path[data.path] or {}
  for _, t in ipairs(threads) do
    if t.root.id == data.thread.root.id then thread = t; break end
  end
  if not thread then return end
  show_thread(bufnr, thread)
end

local function setup_autocmds()
  local group = vim.api.nvim_create_augroup("pr_comments_qf", { clear = true })

  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = group,
    callback = function(args)
      if vim.bo[args.buf].buftype ~= "" then return end
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(args.buf) then return end
        if state then
          local rel = buf_relative_path(args.buf)
          if rel and state.threads_by_path[rel] then
            render_signs(args.buf)
            bind_buffer(args.buf)
          end
        end
        show_thread_for_current_qf_entry()
      end)
    end,
  })
end

local function bind_qf_buffer(qf_winid)
  if not qf_winid or not vim.api.nvim_win_is_valid(qf_winid) then return end
  local qf_bufnr = vim.api.nvim_win_get_buf(qf_winid)
  vim.keymap.set("n", "<CR>", function()
    local lnum = vim.fn.line(".")
    pcall(vim.cmd, "cc " .. lnum)
    show_thread_for_current_qf_entry()
  end, { buffer = qf_bufnr, silent = true, desc = "Open entry + show thread" })
end

local function with_atlas_client(callback)
  local client = atlas_client_mod.new()
  if not client then
    notify(vim.log.levels.WARN, "atlas.nvim Bitbucket API is not available")
    return
  end
  callback(client)
end

local function populate_qf(roots, replies_by_root, root_path)
  local items = {}
  for _, c in ipairs(roots) do
    local replies = replies_by_root[c.id] or {}
    local range = range_from_raw(c) or { start_line = c.anchor.line, end_line = c.anchor.line }
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
  last_shown_idx = nil
  return #items
end

---@param on_done fun(success: boolean)
local function load(on_done)
  on_done = on_done or function() end
  local root = git_root()
  if not root then notify(vim.log.levels.WARN, "Not in a git repository"); on_done(false); return end

  local workspace, repo = parse_origin(root)
  if not workspace or not repo then
    notify(vim.log.levels.WARN, "Origin is not a Bitbucket remote"); on_done(false); return
  end

  local branch = current_branch(root)
  if not branch then notify(vim.log.levels.WARN, "Could not resolve current branch"); on_done(false); return end

  with_atlas_client(function(client)
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
        threads_by_path = threads_by_path,
        current_user = current_user,
      }
      setup_highlights()
      refresh_all_buffers()
      populate_qf(roots, replies_by_root, root)
      on_done(true)
    end

    client.fetch_current_user(function(user, err)
      if err then notify(vim.log.levels.DEBUG, "current user: " .. err) end
      current_user = user
      user_done = true
      maybe_finish()
    end)

    notify(vim.log.levels.INFO, ("Loading PR comments for %s..."):format(branch))
    client.fetch_open_prs(workspace, repo, function(prs, err)
      if err then notify(vim.log.levels.WARN, err); prs_done = true; maybe_finish(); return end
      for _, candidate in ipairs(prs or {}) do
        if (candidate.source or {}).branch == branch then pr = candidate; break end
      end
      if not pr then
        notify(vim.log.levels.WARN, "No open PR for branch " .. branch)
        prs_done = true; maybe_finish(); return
      end

      local url = links.comments(pr)
      if url == "" then
        notify(vim.log.levels.WARN, "PR has no comments URL")
        pr = nil; prs_done = true; maybe_finish(); return
      end

      client.fetch_comments(url, function(values, err2)
        if err2 then notify(vim.log.levels.WARN, err2); pr = nil; prs_done = true; maybe_finish(); return end
        for _, c in ipairs(values or {}) do c._raw = c end
        comments_normalized = bitbucket._normalize_comments(values or {})
        prs_done = true
        maybe_finish()
      end)
    end)
  end)
end

function M.open()
  load(function(success)
    if not success or not state then return end
    local thread_count = 0
    for _, ts in pairs(state.threads_by_path) do thread_count = thread_count + #ts end
    if thread_count == 0 then notify(vim.log.levels.INFO, "No PR comments"); return end
    clear_active_highlight()
    vim.cmd("copen")
    bind_qf_buffer(vim.api.nvim_get_current_win())
    notify(vim.log.levels.INFO, ("Loaded %d threads"):format(thread_count))
  end)
end

function M.toggle()
  if active_popup and active_popup.win and vim.api.nvim_win_is_valid(active_popup.win) then
    active_popup.close()
    active_popup = nil
    return
  end

  if not state then
    load(function(success)
      if not success or not state then return end
      M.toggle()
    end)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local rel = buf_relative_path(bufnr)
  if not rel then notify(vim.log.levels.WARN, "Buffer not in PR"); return end
  local threads = state.threads_by_path[rel]
  if not threads or #threads == 0 then notify(vim.log.levels.WARN, "No threads in this file"); return end

  local cur_line = vim.fn.line(".")
  local thread = thread_for_line(threads, cur_line)
  if not thread then notify(vim.log.levels.WARN, "No thread at cursor"); return end

  show_thread(bufnr, thread)
end

local function refresh_after_mutation()
  load(function(success)
    if success and state then
      local thread_count = 0
      for _, ts in pairs(state.threads_by_path) do thread_count = thread_count + #ts end
      notify(vim.log.levels.INFO, ("Reloaded: %d threads"):format(thread_count))
    end
  end)
end

function M._edit(comment)
  if not state or not state.pr then return end
  local provider = bitbucket.new(atlas_client_mod.new())
  if not provider or not provider.edit_comment then
    notify(vim.log.levels.WARN, "Edit not supported"); return
  end

  comments_ui.input({
    title = " Edit PR comment ",
    initial_body = comment.body or "",
    on_empty = function() notify(vim.log.levels.WARN, "Empty comment, cancelled") end,
    on_submit = function(body)
      provider.edit_comment(state.pr, comment, body, function(_, err)
        if err then notify(vim.log.levels.ERROR, err); return end
        notify(vim.log.levels.INFO, "Comment updated")
        refresh_after_mutation()
      end)
    end,
  })
end

function M._delete(comment, close)
  if not state or not state.pr then return end
  local provider = bitbucket.new(atlas_client_mod.new())
  if not provider or not provider.delete_comment then return end

  local target = comment.in_reply_to_id and "reply" or "thread"
  vim.ui.input({ prompt = ("Delete %s? [y/N]: "):format(target) }, function(input)
    if type(input) ~= "string" or not input:match("^[yY]") then return end
    if close then close() end
    provider.delete_comment(state.pr, comment, function(_, err)
      if err then notify(vim.log.levels.ERROR, err); return end
      notify(vim.log.levels.INFO, target == "reply" and "Reply deleted" or "Thread deleted")
      refresh_after_mutation()
    end)
  end)
end

function M._reply_to(thread)
  if not state or not state.pr then return end
  local provider = bitbucket.new(atlas_client_mod.new())
  if not provider then return end

  comments_ui.input({
    title = (" Reply: %s:%d "):format(thread.root.path or "?", thread.line),
    on_empty = function() notify(vim.log.levels.WARN, "Empty reply, cancelled") end,
    on_submit = function(body)
      provider.reply(state.pr, thread.root, body, function(_, err)
        if err then notify(vim.log.levels.ERROR, err); return end
        notify(vim.log.levels.INFO, "Reply posted")
        refresh_after_mutation()
      end)
    end,
  })
end

setup_autocmds()
setup_highlights()

return M
