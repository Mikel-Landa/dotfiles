-- Diffview session reader. Single seam onto Diffview internals.
-- See CONTEXT.md → "Diffview session reader".
local M = {}

-- Diffview submodules reference `DiffviewGlobal` at top level; a pre-bootstrap
-- require errors and Lua caches the failure sentinel in `package.loaded`.
local function safe_diffview_require(mod)
  if not (_G.DiffviewGlobal and _G.DiffviewGlobal.bootstrap_ok) then return nil end
  local ok, m = pcall(require, mod)
  return ok and m or nil
end

local function rev_to_sha(toplevel, rev)
  if not toplevel or rev == nil or rev == "" then return nil end
  local result = vim.system({ "git", "-C", toplevel, "rev-parse", tostring(rev) }, { text = true }):wait()
  if not result or result.code ~= 0 then return nil end
  return vim.trim(result.stdout)
end

local function bufnr_for(file)
  if not file then return nil end
  local bn = file.bufnr
  if bn and vim.api.nvim_buf_is_valid(bn) then return bn end
  return nil
end

---@class DiffviewSession
---@field git_root string|nil
---@field modified_revision string
---@field original_revision string
---@field modified_path string
---@field original_path string
---@field modified_bufnr integer|nil
---@field original_bufnr integer|nil

---Read a Diffview session for the given tabpage. Returns nil if no view.
---@param tabpage integer|nil
---@return DiffviewSession|nil
function M.read(tabpage)
  local lib = safe_diffview_require("diffview.lib")
  if not lib then return nil end
  local view = tabpage and lib.tabpage_to_view(tabpage) or lib.get_current_view()
  if not view or not view.cur_entry or not view.adapter then return nil end

  local entry = view.cur_entry
  local layout = entry.layout
  if not layout or not layout.a or not layout.b then return nil end

  local toplevel = view.adapter.ctx and view.adapter.ctx.toplevel or nil
  local right = view.right or {}
  local left = view.left or {}

  local modified_revision = right.commit
  if (not modified_revision or modified_revision == "") and right.type then
    modified_revision = ""
  end
  if modified_revision and modified_revision ~= "" and not modified_revision:match("^[0-9a-f]+$") then
    modified_revision = rev_to_sha(toplevel, modified_revision) or modified_revision
  end

  return {
    git_root = toplevel,
    modified_revision = modified_revision or "",
    original_revision = left.commit or "",
    modified_path = entry.path,
    original_path = entry.oldpath ~= "" and entry.oldpath or entry.path,
    modified_bufnr = bufnr_for(layout.b.file),
    original_bufnr = bufnr_for(layout.a.file),
  }
end

---@param session DiffviewSession|nil
function M.has_revision(session)
  if not session then return false end
  local rev = tostring(session.modified_revision or "")
  return rev ~= "" and rev ~= "WORKING" and rev ~= "STAGED"
end

---@param session DiffviewSession
---@param provider_name string
---@return string|nil
function M.session_key(session, provider_name)
  if not M.has_revision(session) then return nil end
  local root = tostring(session.git_root or "")
  if root == "" then return nil end
  return table.concat({ provider_name or "", root, tostring(session.modified_revision) }, ":")
end

---@param session DiffviewSession
---@return string|nil
function M.rel_file_path(session)
  local file_path = (session.original_path ~= "" and session.original_path)
    or (session.modified_path ~= "" and session.modified_path)
  if not file_path then return nil end

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

-- Test seam: allow specs to inject a fake `diffview.lib`.
M._set_lib_loader = function(loader) safe_diffview_require = loader end

return M
