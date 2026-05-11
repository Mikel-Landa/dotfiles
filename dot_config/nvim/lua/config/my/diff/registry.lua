-- Session registry. Per-tabpage sessions map + async refresh state machine.
-- See CONTEXT.md → "Session registry".
local M = {}

local sign_plan = require("config.my.diff.sign_plan")
local render = require("config.my.diff.render")
local codediff_session = require("config.my.diff.codediff_session")

local ns = vim.api.nvim_create_namespace("diff_pr_comments")

---@type table[]
local providers = {}

---@type table<integer, table>
local sessions = {}

local function notify(level, msg)
  vim.notify("[PR comments] " .. tostring(msg), level)
end

---@param list table[]
function M.set_providers(list)
  providers = list or {}
end

---@param tabpage integer|nil
function M.get(tabpage)
  return sessions[tabpage]
end

function M.provider_for(tabpage)
  local view_session = codediff_session.read(tabpage)
  if not view_session then return nil, nil end
  for _, mod in ipairs(providers) do
    if mod.can_handle and mod.can_handle(view_session) then
      return mod, view_session
    end
  end
  return nil, view_session
end

---@param url string  origin URL (ssh or https)
---@return table|nil provider, string|nil workspace, string|nil repo
function M.provider_for_origin_url(url)
  for _, mod in ipairs(providers) do
    if mod.parse_origin_url then
      local workspace, repo = mod.parse_origin_url(url)
      if workspace and repo then
        return mod, workspace, repo
      end
    end
  end
  return nil
end

function M.show(tabpage)
  local s = sessions[tabpage]
  if not s or not s.pr then return end

  local view_session = codediff_session.read(tabpage)
  if not view_session then return end
  local file_path = codediff_session.rel_file_path(view_session)
  if not file_path then return end

  local sides = {
    { side = "LEFT",  bufnr = view_session.original_bufnr },
    { side = "RIGHT", bufnr = view_session.modified_bufnr },
  }
  for _, sb in ipairs(sides) do
    if sb.bufnr then
      local line_count = vim.api.nvim_buf_line_count(sb.bufnr)
      local plan = sign_plan.plan(s.comments, file_path, sb.side, line_count)
      render.apply(sb.bufnr, ns, plan)
    end
  end
end

function M.destroy(tabpage)
  local s = sessions[tabpage]
  if not s then return end
  -- Best-effort: clear the render memo for the buffers we last saw. The view's
  -- buffers may already be invalid if the tab is closing; render.clear_memo is
  -- a plain table delete and tolerates that.
  local view_session = codediff_session.read(tabpage)
  if view_session then
    if view_session.original_bufnr then render.clear_memo(view_session.original_bufnr) end
    if view_session.modified_bufnr then render.clear_memo(view_session.modified_bufnr) end
  end
  sessions[tabpage] = nil
end

-- Wraps a provider callback so it no-ops once the session for `tabpage` has
-- been replaced or its session_key has changed. Race guard for stale fetches
-- arriving after a tab switch / forced refresh.
local function guarded(tabpage, s, key, fn)
  return function(...)
    if sessions[tabpage] ~= s or s.session_key ~= key then return end
    fn(...)
  end
end

function M.refresh(tabpage, opts)
  opts = opts or {}
  tabpage = tabpage or vim.api.nvim_get_current_tabpage()
  local provider, view_session = M.provider_for(tabpage)
  if not provider or not codediff_session.has_revision(view_session) then return end

  local key = codediff_session.session_key(view_session, provider.name)
  local s = sessions[tabpage]
  if opts.force ~= true and s and key and s.session_key == key and s.pr then
    M.show(tabpage)
    return
  end
  if s and key and s.loading_key == key then return end

  s = {
    provider = provider,
    session_key = key,
    loading_key = key,
    pr = nil,
    comments = {},
    diff_files = {},
  }
  sessions[tabpage] = s
  notify(vim.log.levels.INFO, "Loading PR comments...")

  provider.find_pr(view_session, guarded(tabpage, s, key, function(pr, pr_err)
    if pr_err then s.loading_key = nil; notify(vim.log.levels.WARN, pr_err); return end
    if not pr then s.loading_key = nil; notify(vim.log.levels.WARN, "No PR found"); return end

    s.pr = pr
    local loaded = { diff = false, comments = false }

    local function finish()
      if not loaded.diff or not loaded.comments then return end
      s.loading_key = nil
      M.show(tabpage)
      notify(vim.log.levels.INFO, ("Loaded %d PR comments"):format(#s.comments))
    end

    provider.fetch_diff_files(pr, guarded(tabpage, s, key, function(files)
      s.diff_files = files or {}
      loaded.diff = true
      finish()
    end))

    provider.fetch_comments(pr, guarded(tabpage, s, key, function(comments, comments_err)
      if comments_err then
        s.loading_key = nil; s.pr = nil; s.session_key = nil
        notify(vim.log.levels.WARN, comments_err); return
      end
      s.comments = comments or {}
      loaded.comments = true
      finish()
    end))
  end))
end

-- Test seam: expose internal sessions map.
M.__sessions = sessions

-- Test seam: swap the codediff_session reader (e.g. with a stub).
function M._set_session_reader(stub)
  codediff_session = stub
end

return M
