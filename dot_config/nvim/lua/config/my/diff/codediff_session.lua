-- CodeDiff session reader. Single seam onto codediff internals.
-- See CONTEXT.md → "CodeDiff session reader".
local M = {}

local function safe_codediff_require(mod)
  local ok, m = pcall(require, mod)
  return ok and m or nil
end

local function rev_to_sha(toplevel, rev)
  if not toplevel or rev == nil or rev == "" then return nil end
  local result = vim.system({ "git", "-C", toplevel, "rev-parse", tostring(rev) }, { text = true }):wait()
  if not result or result.code ~= 0 then return nil end
  return vim.trim(result.stdout)
end

local function valid_bufnr(bufnr)
  if bufnr and vim.api.nvim_buf_is_valid(bufnr) then return bufnr end
  return nil
end

---@class CodeDiffSession
---@field git_root string|nil
---@field modified_revision string
---@field original_revision string
---@field modified_path string
---@field original_path string
---@field modified_bufnr integer|nil
---@field original_bufnr integer|nil

---Read a CodeDiff session for the given tabpage. Returns nil if no view.
---@param tabpage integer|nil
---@return CodeDiffSession|nil
function M.read(tabpage)
  local lifecycle = safe_codediff_require("codediff.ui.lifecycle")
  if not lifecycle or not lifecycle.get_session then return nil end
  local tp = tabpage or vim.api.nvim_get_current_tabpage()
  local sess = lifecycle.get_session(tp)
  if not sess then return nil end

  local toplevel = sess.git_root
  local modified_revision = sess.modified_revision or ""
  if modified_revision ~= "" and modified_revision ~= "WORKING" and modified_revision ~= "STAGED"
    and not modified_revision:match("^[0-9a-f]+$") then
    modified_revision = rev_to_sha(toplevel, modified_revision) or modified_revision
  end

  return {
    git_root = toplevel,
    modified_revision = modified_revision,
    original_revision = sess.original_revision or "",
    modified_path = sess.modified_path or "",
    original_path = (sess.original_path ~= "" and sess.original_path) or sess.modified_path or "",
    modified_bufnr = valid_bufnr(sess.modified_bufnr),
    original_bufnr = valid_bufnr(sess.original_bufnr),
  }
end

---@param session CodeDiffSession|nil
function M.has_revision(session)
  if not session then return false end
  local rev = tostring(session.modified_revision or "")
  return rev ~= "" and rev ~= "WORKING" and rev ~= "STAGED"
end

---@param session CodeDiffSession
---@param provider_name string
---@return string|nil
function M.session_key(session, provider_name)
  if not M.has_revision(session) then return nil end
  local root = tostring(session.git_root or "")
  if root == "" then return nil end
  return table.concat({ provider_name or "", root, tostring(session.modified_revision) }, ":")
end

---@param session CodeDiffSession
---@return string|nil
function M.rel_file_path(session)
  local file_path = (session.original_path ~= "" and session.original_path)
    or (session.modified_path ~= "" and session.modified_path)
  if not file_path or file_path == "" then return nil end

  local root = tostring(session.git_root or "")
  if root ~= "" then
    local prefix = root .. "/"
    if file_path:sub(1, #prefix) == prefix then
      file_path = file_path:sub(#prefix + 1)
    end
  end
  return file_path
end

function M.tabpage_from_event(event)
  return event and event.data and event.data.tabpage or vim.api.nvim_get_current_tabpage()
end

-- Test seam: allow specs to inject a fake `codediff.ui.lifecycle`.
M._set_lifecycle_loader = function(loader) safe_codediff_require = loader end

return M
