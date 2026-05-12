-- Shared helpers for diff/* modules. Pure utility seam — no state beyond the
-- per-root origin URL memo. Adapters and qf.lua import from here instead of
-- inlining `trim`/`notify`/git shell-outs.
local M = {}

function M.trim(value)
  if type(value) ~= "string" then return "" end
  return vim.trim(value)
end

function M.notify(level, msg)
  vim.notify("[PR comments] " .. tostring(msg), level)
end

M.git = {}

local function run_git(args)
  local result = vim.system(args, { text = true }):wait()
  if not result or result.code ~= 0 then return nil end
  local out = M.trim(result.stdout)
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

-- Memoized per root: `git remote get-url origin` is invariant across the
-- session and gets hit 3× per PR-load by the provider chain otherwise.
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

return M
