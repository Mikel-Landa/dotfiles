-- Compressed view for CodeDiff buffers: fold away unchanged regions, leaving
-- only changed lines plus N context lines. Toggle per-tab with `<leader>gz`
-- (or `gz` inside a diff window). codediff uses extmarks (not vim diff mode),
-- so foldmethod=diff doesn't apply — we derive folds from its extmarks.

local M = {}

local codediff_session = require("config.my.diff.codediff_session")

local CONTEXT = 5
-- codediff splits highlights across two namespaces — side-by-side vs inline.
local NS_HL = vim.api.nvim_create_namespace("codediff-highlight")
local NS_INLINE = vim.api.nvim_create_namespace("codediff-inline")

-- Module-local rather than `vim.b` because vim variable serialization coerces
-- sparse integer keys to strings, breaking the numeric lookup in `expr()`.
local buf_cache = {}

-- Per-tab state: { enabled (bool), token (supersession counter) }.
local tabs = {}

local function collect_marks(bufnr)
  local out = vim.api.nvim_buf_get_extmarks(bufnr, NS_HL, 0, -1, {})
  for _, m in ipairs(vim.api.nvim_buf_get_extmarks(bufnr, NS_INLINE, 0, -1, {})) do
    out[#out + 1] = m
  end
  return out
end

local function compute_keep(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then return {} end
  local tick = vim.api.nvim_buf_get_changedtick(bufnr)
  local cached = buf_cache[bufnr]
  if cached and cached.tick == tick then return cached.keep end

  local marks = collect_marks(bufnr)
  if #marks == 0 then return {} end

  local total = vim.api.nvim_buf_line_count(bufnr)
  local keep = {}
  for _, m in ipairs(marks) do
    local row = m[2]
    local lo = math.max(1, row + 1 - CONTEXT)
    local hi = math.min(total, row + 1 + CONTEXT)
    for ln = lo, hi do keep[ln] = true end
  end
  buf_cache[bufnr] = { keep = keep, tick = tick }
  return keep
end

local function apply_to_win(win)
  if not vim.api.nvim_win_is_valid(win) then return false end
  local bufnr = vim.api.nvim_win_get_buf(win)
  local keep = compute_keep(bufnr)
  if next(keep) == nil then return false end

  vim.api.nvim_win_call(win, function()
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.require'config.my.codediff_folds'.expr()"
    vim.wo.foldlevel = 0
    vim.wo.foldenable = true
    vim.wo.foldtext = "v:lua.require'config.my.codediff_folds'.foldtext()"
    vim.opt_local.fillchars:append({ fold = " " })
  end)
  return true
end

local function clear_in_win(win)
  if not vim.api.nvim_win_is_valid(win) then return end
  vim.api.nvim_win_call(win, function()
    vim.wo.foldenable = false
  end)
end

local function tab_wins(tabpage)
  if not vim.api.nvim_tabpage_is_valid(tabpage) then return {} end
  return vim.api.nvim_tabpage_list_wins(tabpage)
end

function M.expr()
  local cached = buf_cache[vim.api.nvim_get_current_buf()]
  if not cached then return "0" end
  return cached.keep[vim.v.lnum] and "0" or "1"
end

function M.foldtext()
  local count = vim.v.foldend - vim.v.foldstart + 1
  return ("  ⋯ %d unchanged lines"):format(count)
end

local function apply_tab(tabpage)
  local any = false
  for _, win in ipairs(tab_wins(tabpage)) do
    if apply_to_win(win) then any = true end
  end
  return any
end

local function clear_tab(tabpage)
  for _, win in ipairs(tab_wins(tabpage)) do
    clear_in_win(win)
  end
end

function M.toggle(tabpage)
  tabpage = tabpage or vim.api.nvim_get_current_tabpage()
  local t = tabs[tabpage] or { enabled = true, token = 0 }
  tabs[tabpage] = t
  if t.enabled == false then
    t.enabled = true
    apply_tab(tabpage)
  else
    t.enabled = false
    clear_tab(tabpage)
  end
end

local function bind_toggle(tabpage)
  for _, win in ipairs(tab_wins(tabpage)) do
    local bufnr = vim.api.nvim_win_get_buf(win)
    vim.keymap.set("n", "gz", function() M.toggle() end,
      { buffer = bufnr, desc = "CodeDiff: toggle compressed view" })
  end
end

local group = vim.api.nvim_create_augroup("my_codediff_folds", { clear = true })

-- Per-tab scheduling. A new schedule_apply bumps the token, so any in-flight
-- retry chain sees the change and bails — prevents stacking when codediff
-- fires FileSelect repeatedly.
local function schedule_apply(tabpage)
  local t = tabs[tabpage] or { enabled = true, token = 0 }
  tabs[tabpage] = t
  if t.enabled == false then return end
  t.token = t.token + 1
  local token = t.token
  local tries = 0
  local function attempt()
    if (tabs[tabpage] or {}).token ~= token then return end
    if not vim.api.nvim_tabpage_is_valid(tabpage) then return end
    tries = tries + 1
    if apply_tab(tabpage) then
      bind_toggle(tabpage)
      return
    end
    if tries < 8 then vim.defer_fn(attempt, 100) end
  end
  vim.defer_fn(attempt, 80)
end

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "CodeDiffOpen",
  callback = function(event)
    local tabpage = codediff_session.tabpage_from_event(event)
    tabs[tabpage] = { enabled = true, token = (tabs[tabpage] or {}).token or 0 }
    schedule_apply(tabpage)
  end,
})

-- Explorer mode reuses the tab on file-select; CodeDiffOpen doesn't re-fire.
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "CodeDiffFileSelect",
  callback = function(event)
    schedule_apply(codediff_session.tabpage_from_event(event))
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "CodeDiffClose",
  callback = function(event)
    local tabpage = event.data and event.data.tabpage
    if tabpage then tabs[tabpage] = nil end
  end,
})

vim.api.nvim_create_autocmd("BufWipeout", {
  group = group,
  callback = function(event) buf_cache[event.buf] = nil end,
})

vim.keymap.set("n", "<leader>gz", function() M.toggle() end,
  { desc = "CodeDiff: toggle compressed view" })

return M
