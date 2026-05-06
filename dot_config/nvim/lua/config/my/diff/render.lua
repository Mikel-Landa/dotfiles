local M = {}

-- Per-buffer fingerprint of the last applied plan. Buffers absent from this
-- table re-render unconditionally.
local applied = {}

local function fingerprint(plan)
  local lines = {}
  for line in pairs(plan) do table.insert(lines, line) end
  table.sort(lines)
  local parts = {}
  for _, line in ipairs(lines) do
    local s = plan[line]
    table.insert(parts, ("%d:%s:%s:%d"):format(line, s.icon, s.hl, s.priority))
  end
  return table.concat(parts, "|")
end

---@param bufnr integer
---@param ns    integer
---@param plan  table<integer, { icon: string, hl: string, priority: integer }>
function M.apply(bufnr, ns, plan)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then return end

  local fp = fingerprint(plan or {})
  if applied[bufnr] == fp then return end
  applied[bufnr] = fp

  for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
    if vim.api.nvim_win_is_valid(win) then
      vim.wo[win].signcolumn = "yes:1"
    end
  end

  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  for line, spec in pairs(plan or {}) do
    vim.api.nvim_buf_set_extmark(bufnr, ns, line - 1, 0, {
      sign_text = spec.icon,
      sign_hl_group = spec.hl,
      priority = spec.priority,
    })
  end
end

---@param bufnr integer
function M.clear_memo(bufnr)
  applied[bufnr] = nil
end

return M
