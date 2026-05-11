-- PR comments overlay: thin glue. Wires keymaps → commands and
-- autocmds → registry. State lives in registry.lua, user actions in
-- commands.lua, Diffview reads in diffview_session.lua.
local registry = require("config.my.diff.registry")
local commands = require("config.my.diff.commands")
local diffview_session = require("config.my.diff.diffview_session")
local qf = require("config.my.diff.qf")

-- Provider construction is deferred and memoized per-kind: lazy plugins
-- (atlas.nvim is `cmd`-loaded) may not be on the runtimepath when this file
-- runs, so we re-attempt on every lookup until each provider resolves.
local cache = {}

local function ensure_atlas_loaded()
  pcall(function()
    local lazy = require("lazy")
    if lazy and lazy.load then lazy.load({ plugins = { "atlas.nvim" }, show = false }) end
  end)
end

local function build_providers()
  if not cache.bitbucket then
    ensure_atlas_loaded()
    local atlas_client = require("config.my.diff.providers.atlas_client").new()
    if atlas_client then
      cache.bitbucket = require("config.my.diff.providers.bitbucket").new(atlas_client)
    end
  end
  if not cache.github then
    local gh_client = require("config.my.diff.providers.gh_client").new()
    if gh_client then
      cache.github = require("config.my.diff.providers.github").new(gh_client)
    end
  end
  local list = {}
  if cache.bitbucket then table.insert(list, cache.bitbucket) end
  if cache.github then table.insert(list, cache.github) end
  return list
end

registry.set_provider_factory(build_providers)

vim.keymap.set("n", "<leader>oc", qf.open, { desc = "PR comments → quickfix" })
vim.keymap.set("n", "<leader>oC", qf.close, { desc = "PR comments: clear (qf + signs + K)" })

local group = vim.api.nvim_create_augroup("my_diff_comments", { clear = true })

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "DiffviewViewOpened",
  callback = function(event)
    vim.schedule(function() registry.refresh(diffview_session.tabpage_from_event(event)) end)
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "DiffviewDiffBufRead",
  callback = function(event)
    local tabpage = diffview_session.tabpage_from_event(event)
    vim.schedule(function() registry.show(tabpage) end)
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "DiffviewDiffBufWinEnter",
  callback = function(event)
    local tabpage = diffview_session.tabpage_from_event(event)
    vim.schedule(function()
      registry.refresh(tabpage)
      vim.defer_fn(function() registry.show(tabpage) end, 50)
    end)
  end,
})

vim.api.nvim_create_autocmd("WinEnter", {
  group = group,
  callback = function()
    local tabpage = vim.api.nvim_get_current_tabpage()
    vim.schedule(function() registry.show(tabpage) end)
  end,
})

vim.api.nvim_create_autocmd("TabClosed", {
  group = group,
  callback = function(event)
    local tab = tonumber(event.match)
    if tab then registry.destroy(tab) end
  end,
})

return {
  registry = registry,
  commands = commands,
}
