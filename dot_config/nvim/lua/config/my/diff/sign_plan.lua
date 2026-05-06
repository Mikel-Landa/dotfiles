---@class SignSpec
---@field icon     string
---@field hl       string
---@field priority integer

---@class PRComment
---@field id              string|integer
---@field anchor          { side: "LEFT"|"RIGHT", line: integer }
---@field path            string
---@field body            string
---@field user            string|nil
---@field created_at      string|nil
---@field pending         boolean
---@field in_reply_to_id  string|integer|nil
---@field _raw            any

local M = {}

local SIGN_PUBLISHED = { icon = "●", hl = "DiagnosticInfo", priority = 1000 }
local SIGN_PENDING   = { icon = "○", hl = "DiagnosticHint", priority = 1000 }

---@param comments PRComment[]
---@param path string
---@param side "LEFT"|"RIGHT"
---@param line_count integer  buffer line count; anchors past this are dropped
---@return table<integer, SignSpec>
function M.plan(comments, path, side, line_count)
  local out = {}
  if type(comments) ~= "table" or line_count == nil then return out end

  local has_pending = {}
  for _, c in ipairs(comments) do
    if c.in_reply_to_id == nil
      and c.path == path
      and c.anchor and c.anchor.side == side
    then
      local line = c.anchor.line
      if type(line) == "number" and line >= 1 and line <= line_count then
        if c.pending then has_pending[line] = true end
        out[line] = c.pending and SIGN_PENDING or (out[line] or SIGN_PUBLISHED)
      end
    end
  end

  for line in pairs(has_pending) do
    out[line] = SIGN_PENDING
  end

  return out
end

return M
