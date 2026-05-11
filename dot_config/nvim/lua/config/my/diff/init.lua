-- PR comments overlay: thin glue. Wires keymaps → commands and
-- autocmds → registry. State lives in registry.lua, user actions in
-- commands.lua, CodeDiff reads in codediff_session.lua.
local registry = require("config.my.diff.registry")
local commands = require("config.my.diff.commands")
local codediff_session = require("config.my.diff.codediff_session")
local qf = require("config.my.diff.qf")

local providers = {}

local atlas_client = require("config.my.diff.providers.atlas_client").new()
if atlas_client then
  local bitbucket = require("config.my.diff.providers.bitbucket").new(atlas_client)
  if bitbucket then table.insert(providers, bitbucket) end
end

local gh_client = require("config.my.diff.providers.gh_client").new()
if gh_client then
  local github = require("config.my.diff.providers.github").new(gh_client)
  if github then table.insert(providers, github) end
end

registry.set_providers(providers)

vim.keymap.set("n", "<leader>oc", qf.open, { desc = "PR comments → quickfix" })
vim.keymap.set("n", "<leader>oC", qf.close, { desc = "PR comments: clear (qf + signs + K)" })

local group = vim.api.nvim_create_augroup("my_diff_comments", { clear = true })

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "CodeDiffOpen",
  callback = function(event)
    vim.schedule(function() registry.refresh(codediff_session.tabpage_from_event(event)) end)
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "CodeDiffFileSelect",
  callback = function(event)
    local tabpage = codediff_session.tabpage_from_event(event)
    vim.schedule(function()
      registry.refresh(tabpage)
      vim.defer_fn(function() registry.show(tabpage) end, 50)
    end)
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "CodeDiffClose",
  callback = function(event)
    local tabpage = codediff_session.tabpage_from_event(event)
    registry.destroy(tabpage)
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
