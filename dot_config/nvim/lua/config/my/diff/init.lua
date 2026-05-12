-- PR comments overlay: thin glue. Wires keymaps → commands and
-- autocmds → registry. State lives in registry.lua, user actions in
-- commands.lua, CodeDiff reads in codediff_session.lua.
local registry = require("config.my.diff.registry")
local commands = require("config.my.diff.commands")
local codediff_session = require("config.my.diff.codediff_session")
local qf = require("config.my.diff.qf")

-- Factories: deferred so atlas.nvim (lazy-loaded via `cmd`) has a chance to be
-- packadded before we probe its API. Resolved on the first registry lookup
-- (typically from a CodeDiffOpen autocmd, well after `lazy.setup()` returns).
local function bitbucket_factory()
  pcall(function()
    require("lazy.core.loader").load("atlas.nvim", { cmd = "PR comments overlay" })
  end)
  local atlas_client = require("config.my.diff.providers.atlas_client").new()
  if not atlas_client then return nil end
  return require("config.my.diff.providers.bitbucket").new(atlas_client)
end

local function github_factory()
  local gh_client = require("config.my.diff.providers.gh_client").new()
  if not gh_client then return nil end
  return require("config.my.diff.providers.github").new(gh_client)
end

registry.set_providers({ bitbucket_factory, github_factory })

vim.keymap.set("n", "<leader>oc", qf.open, { desc = "PR comments → quickfix" })
vim.keymap.set("n", "<leader>oC", qf.close, { desc = "PR comments: clear (qf + signs + K)" })

local group = vim.api.nvim_create_augroup("my_diff_comments", { clear = true })

-- Sticky overlay: no auto-load on CodeDiffOpen. First fetch must come from an
-- explicit invocation (qf.open's <leader>oc seeds the registry; manual
-- commands.reload also works). Once a tabpage has a registry session, file
-- switches inside that tab re-fetch so signs stay in sync with the new file.
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "CodeDiffFileSelect",
  callback = function(event)
    local tabpage = codediff_session.tabpage_from_event(event)
    if not registry.get(tabpage) then return end
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
