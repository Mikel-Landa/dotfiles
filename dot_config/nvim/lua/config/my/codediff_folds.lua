-- Compressed view for CodeDiff buffers: fold away unchanged regions, leaving
-- only changed lines plus N lines of context. Toggle per-tab with `<leader>gz`
-- (or `gz` inside a diff window). Applied automatically on `CodeDiffOpen`.
--
-- Strategy: codediff renders diffs via extmarks rather than vim's diff mode,
-- so `foldmethod=diff` does not apply. Scan codediff's per-buffer extmarks to
-- derive a set of "kept" lines (changed ± context) and drive a
-- `foldmethod=expr` foldexpr from it.

local M = {}

local CONTEXT = 5
-- codediff splits highlights across namespaces: `codediff-highlight` for
-- side-by-side, `codediff-inline` for inline layout. Scan both.
local NS_HL = vim.api.nvim_create_namespace("codediff-highlight")
local NS_INLINE = vim.api.nvim_create_namespace("codediff-inline")

-- Module-local cache of "kept" line sets, keyed by bufnr. Stored here rather
-- than on `vim.b` because vim variable serialization coerces sparse integer
-- keys to strings, breaking the numeric lookup in `expr()`.
local keep_by_buf = {}

local function collect_marks(bufnr)
  local out = vim.api.nvim_buf_get_extmarks(bufnr, NS_HL, 0, -1, {})
  for _, m in ipairs(vim.api.nvim_buf_get_extmarks(bufnr, NS_INLINE, 0, -1, {})) do
    out[#out + 1] = m
  end
  return out
end

local function compute_keep(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then return {} end
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
  return keep
end

local function apply_to_win(win)
  if not vim.api.nvim_win_is_valid(win) then return false end
  local bufnr = vim.api.nvim_win_get_buf(win)
  local keep = compute_keep(bufnr)
  if next(keep) == nil then return false end

  keep_by_buf[bufnr] = keep
  vim.api.nvim_win_call(win, function()
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.require'config.my.codediff_folds'.expr()"
    vim.wo.foldlevel = 0
    vim.wo.foldenable = true
    vim.wo.foldtext = "v:lua.require'config.my.codediff_folds'.foldtext()"
    vim.wo.fillchars = vim.wo.fillchars .. (vim.wo.fillchars ~= "" and "," or "") .. "fold: "
  end)
  return true
end

local function clear_in_win(win)
  if not vim.api.nvim_win_is_valid(win) then return end
  vim.api.nvim_win_call(win, function()
    vim.wo.foldenable = false
  end)
end

-- Per-tab compressed/expanded state. Default = compressed (true).
local tab_state = {}

local function tab_wins(tabpage)
  if not vim.api.nvim_tabpage_is_valid(tabpage) then return {} end
  return vim.api.nvim_tabpage_list_wins(tabpage)
end

function M.expr()
  local keep = keep_by_buf[vim.api.nvim_get_current_buf()]
  if not keep then return "0" end
  return keep[vim.v.lnum] and "0" or "1"
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
  if tab_state[tabpage] == false then
    tab_state[tabpage] = true
    apply_tab(tabpage)
  else
    tab_state[tabpage] = false
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

-- Per-tab scheduling. A new schedule_apply call supersedes any pending one
-- (the in-flight attempt sees its token bumped and bails). Stops retry chains
-- from stacking when codediff fires FileSelect repeatedly (e.g. its
-- auto-refresh path re-renders the explorer on buffer changes).
local schedule_tokens = {}

local function schedule_apply(tabpage)
  if tab_state[tabpage] == false then return end
  schedule_tokens[tabpage] = (schedule_tokens[tabpage] or 0) + 1
  local token = schedule_tokens[tabpage]
  local tries = 0
  local function attempt()
    if schedule_tokens[tabpage] ~= token then return end
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
    local tabpage = event.data and event.data.tabpage or vim.api.nvim_get_current_tabpage()
    tab_state[tabpage] = true
    schedule_apply(tabpage)
  end,
})

-- Explorer mode reuses the same tab when the user selects a different file;
-- new extmarks render but CodeDiffOpen does not re-fire, so we listen for
-- file-select and re-derive folds.
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "CodeDiffFileSelect",
  callback = function(event)
    local tabpage = event.data and event.data.tabpage or vim.api.nvim_get_current_tabpage()
    schedule_apply(tabpage)
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "CodeDiffClose",
  callback = function(event)
    local tabpage = event.data and event.data.tabpage
    if tabpage then tab_state[tabpage] = nil end
  end,
})

vim.api.nvim_create_autocmd("BufWipeout", {
  group = group,
  callback = function(event) keep_by_buf[event.buf] = nil end,
})

vim.keymap.set("n", "<leader>gz", function() M.toggle() end,
  { desc = "CodeDiff: toggle compressed view" })

return M
