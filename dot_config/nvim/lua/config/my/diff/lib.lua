-- Shared helpers for diff/* modules.
local M = {}

function M.notify(level, msg)
  vim.notify("[PR comments] " .. tostring(msg), level)
end

M.git = {}

local function run_git(args)
  local result = vim.system(args, { text = true }):wait()
  if not result or result.code ~= 0 then return nil end
  local out = vim.trim(result.stdout or "")
  return out ~= "" and out or nil
end

function M.git.root(cwd)
  local args = { "git", "rev-parse", "--show-toplevel" }
  if cwd and cwd ~= "" then table.insert(args, 2, "-C"); table.insert(args, 3, cwd) end
  return run_git(args)
end

function M.git.current_branch(root)
  if type(root) ~= "string" or root == "" then return nil end
  return run_git({ "git", "-C", root, "rev-parse", "--abbrev-ref", "HEAD" })
end

-- Memoized: `git remote get-url origin` is invariant across a session and the
-- provider chain hits it 3× per PR-load otherwise.
local origin_cache = {}

function M.git.origin_url(root)
  if type(root) ~= "string" or root == "" then return nil end
  local cached = origin_cache[root]
  if cached ~= nil then return cached or nil end
  local url = run_git({ "git", "-C", root, "remote", "get-url", "origin" })
  origin_cache[root] = url or false
  return url
end

function M.git.clear_origin_cache()
  origin_cache = {}
end

-- Dedup normalized comments by id (or anchor+body when id missing).
function M.dedup_comments(comments)
  local out, seen = {}, {}
  for _, c in ipairs(comments or {}) do
    if c.path and c.anchor then
      local key = tostring(c.id or "")
      if key == "" then
        key = table.concat({
          c.path or "", c.anchor.side or "",
          tostring(c.anchor.line or ""), c.body or "",
        }, ":")
      end
      if not seen[key] then
        seen[key] = true
        out[#out + 1] = c
      end
    end
  end
  return out
end

return M
