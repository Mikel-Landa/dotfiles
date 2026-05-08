-- Thread finder. Pure: maps (comments, location) to { root, replies }.
-- See CONTEXT.md → "Thread finder".
local M = {}

---@class Location
---@field file_path string
---@field side "LEFT"|"RIGHT"
---@field line integer

---@param comments PRComment[]
---@param location Location
---@return { root: PRComment, replies: PRComment[] }|nil
function M.at(comments, location)
  if type(comments) ~= "table" or type(location) ~= "table" then return nil end

  local root
  for _, c in ipairs(comments) do
    if c.in_reply_to_id == nil
      and c.path == location.file_path
      and c.anchor and c.anchor.side == location.side
      and c.anchor.line == location.line
    then
      root = c; break
    end
  end
  if not root then return nil end

  local replies = {}
  for _, c in ipairs(comments) do
    if c.in_reply_to_id == root.id then
      table.insert(replies, c)
    end
  end
  table.sort(replies, function(a, b) return tostring(a.id) < tostring(b.id) end)

  return { root = root, replies = replies }
end

return M
