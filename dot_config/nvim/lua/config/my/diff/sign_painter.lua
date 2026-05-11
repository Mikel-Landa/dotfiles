-- Sign painter for the working-tree PR-comments overlay. Paints sign-column
-- extmarks on code buffers based on a `{ root, threads_by_path }` state, and
-- exposes per-buffer thread lookups for the K peek-or-hover binding. No
-- autocmds, no provider knowledge — callers (qf.lua) drive refreshes.
-- See CONTEXT.md → "Sign painter".
local M = {}

local SIGN_HL = "PRCommentSign"
local SIGN_PENDING_HL = "PRCommentSignPending"
local SIGN_ICON = "▌"
local sign_ns = vim.api.nvim_create_namespace("pr_comments_signs")

---@type { root: string, threads_by_path: table<string, table[]> }|nil
local state

function M.setup_highlights()
  if vim.fn.hlexists(SIGN_HL) == 0 then
    vim.api.nvim_set_hl(0, SIGN_HL, { fg = "#c6a0f6", bold = true })
  end
  if vim.fn.hlexists(SIGN_PENDING_HL) == 0 then
    vim.api.nvim_set_hl(0, SIGN_PENDING_HL, { fg = "#f5a97f", bold = true })
  end
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

---@param bufnr integer
---@return table[]|nil  list of threads anchored to this buffer's relative path
function M.threads_for_buffer(bufnr)
  if not state then return nil end
  if not vim.api.nvim_buf_is_valid(bufnr) then return nil end
  if vim.bo[bufnr].buftype ~= "" then return nil end
  local rel = buf_relative_path(bufnr)
  if not rel then return nil end
  local threads = state.threads_by_path[rel]
  if not threads or #threads == 0 then return nil end
  return threads
end

function M.refresh_buffer(bufnr)
  clear_signs(bufnr)
  local threads = M.threads_for_buffer(bufnr)
  if not threads then return end

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

function M.refresh_all()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      M.refresh_buffer(bufnr)
    end
  end
end

---@param new_state { root: string, threads_by_path: table<string, table[]> }|nil
function M.set_state(new_state)
  state = new_state
  if state then M.setup_highlights() end
  M.refresh_all()
end

return M
