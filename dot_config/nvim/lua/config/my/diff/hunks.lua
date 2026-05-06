---@class Hunk
---@field left_start integer
---@field left_count integer
---@field right_start integer
---@field right_count integer

local M = {}

local HUNK_HEADER = "@@ %-(%d+),?(%d*) %+(%d+),?(%d*) @@"

local function header_match(header)
  local ls, lc, rs, rc = tostring(header):match(HUNK_HEADER)
  if not ls then return nil end
  return {
    left_start = tonumber(ls),
    left_count = tonumber(lc) or 1,
    right_start = tonumber(rs),
    right_count = tonumber(rc) or 1,
  }
end

---@param file table  adapter diff file entry; either { hunks = { { header, ... }, ... } } or { patch|raw = "..." }
---@return Hunk[]
function M.parse(file)
  if not file then return {} end

  if type(file.hunks) == "table" then
    local out = {}
    for _, hunk in ipairs(file.hunks) do
      local h = header_match(hunk.header or hunk)
      if h then table.insert(out, h) end
    end
    if #out > 0 then return out end
  end

  local out = {}
  local text = tostring(file.patch or file.raw or "")
  for ls, lc, rs, rc in text:gmatch(HUNK_HEADER) do
    table.insert(out, {
      left_start = tonumber(ls),
      left_count = tonumber(lc) or 1,
      right_start = tonumber(rs),
      right_count = tonumber(rc) or 1,
    })
  end
  return out
end

---@param hunks Hunk[]
---@param start_line integer
---@param end_line integer
---@param side "LEFT"|"RIGHT"
---@return boolean
function M.contains(hunks, start_line, end_line, side)
  for _, h in ipairs(hunks or {}) do
    local hstart = side == "LEFT" and h.left_start or h.right_start
    local hcount = side == "LEFT" and h.left_count or h.right_count
    local hend = hstart + hcount - 1
    if start_line >= hstart and end_line <= hend then return true end
  end
  return false
end

return M
