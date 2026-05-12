-- Bitbucket URL extractors over a PR's _raw payload. Owns Bitbucket
-- link-schema quirks so call sites read as routing, not table archaeology.
local M = {}

local function href(links, key)
  return tostring((links[key] or {}).href or links[key] or "")
end

local function pr_links(pr) return (pr and pr._raw or {}).links or {} end
local function comment_links(c) return (c and c._raw or {}).links or {} end

function M.diff(pr) return href(pr_links(pr), "diff") end
function M.comments(pr) return href(pr_links(pr), "comments") end
function M.approve(pr) return href(pr_links(pr), "approve") end

function M.request_changes(pr)
  local links = pr_links(pr)
  local out = href(links, "request-changes")
  return out ~= "" and out or href(links, "request_changes")
end

function M.html(pr)
  local out = href(pr_links(pr), "html")
  if out ~= "" then return out end
  return tostring(pr and pr.link and pr.link.html or "")
end

function M.self(comment) return href(comment_links(comment), "self") end

return M
