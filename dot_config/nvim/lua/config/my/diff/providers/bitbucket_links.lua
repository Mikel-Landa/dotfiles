-- Bitbucket links. Pure URL extractors over a PR's _raw payload.
-- See CONTEXT.md → "Bitbucket links". Owns Bitbucket link-schema quirks
-- (key forks like `request-changes` vs `request_changes`, defensive
-- nil-walking) so call sites read as routing.
local M = {}

local function pr_links(pr)
  return (pr and pr._raw or {}).links or {}
end

local function comment_links(comment)
  return (comment and comment._raw or {}).links or {}
end

---@param pr table
---@return string  empty string when missing
function M.diff(pr)
  local links = pr_links(pr)
  return tostring((links.diff or {}).href or links.diff or "")
end

---@param pr table
---@return string  empty string when missing
function M.comments(pr)
  local links = pr_links(pr)
  return tostring((links.comments or {}).href or links.comments or "")
end

---@param pr table
---@return string  empty string when missing
function M.approve(pr)
  local links = pr_links(pr)
  return tostring((links.approve or {}).href or links.approve or "")
end

---@param pr table
---@return string  empty string when missing
function M.request_changes(pr)
  local links = pr_links(pr)
  return tostring((links["request-changes"] or {}).href or links.request_changes or "")
end

---@param pr table
---@return string  empty string when missing
function M.html(pr)
  local links = pr_links(pr)
  return tostring((links.html or {}).href or links.html or pr and pr.link and pr.link.html or "")
end

---@param comment table
---@return string  empty string when missing
function M.self(comment)
  local links = comment_links(comment)
  return tostring((links.self or {}).href or links.self or "")
end

return M
