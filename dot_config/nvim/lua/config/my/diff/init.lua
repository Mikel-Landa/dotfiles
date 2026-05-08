-- PR comments overlay: thin glue. Wires keymaps → commands and
-- autocmds → registry. State lives in registry.lua, user actions in
-- commands.lua, Diffview reads in diffview_session.lua.
local registry = require("config.my.diff.registry")
local commands = require("config.my.diff.commands")
local diffview_session = require("config.my.diff.diffview_session")
local qf = require("config.my.diff.qf")

local atlas_client = require("config.my.diff.providers.atlas_client").new()
local providers = {}
if atlas_client then
  local bitbucket = require("config.my.diff.providers.bitbucket").new(atlas_client)
  if bitbucket then table.insert(providers, bitbucket) end
end
registry.set_providers(providers)

vim.keymap.set("n", "<leader>oc", qf.open, { desc = "PR comments → quickfix" })

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
