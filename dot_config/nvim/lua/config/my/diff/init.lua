-- PR comments overlay: thin glue. Wires keymaps → commands and
-- autocmds → registry. State lives in registry.lua, user actions in
-- commands.lua, Diffview reads in diffview_session.lua.
local registry = require("config.my.diff.registry")
local commands = require("config.my.diff.commands")
local diffview_session = require("config.my.diff.diffview_session")

registry.set_providers({
  require("config.my.diff.providers.bitbucket"),
})

vim.keymap.set("v", "<leader>occ", function() commands.add_comment_visual(true) end, { desc = "Add pending PR comment" })
vim.keymap.set("n", "<leader>occ", function() commands.add_comment_normal(true) end, { desc = "Add pending PR comment" })
vim.keymap.set("v", "<leader>ocC", function() commands.add_comment_visual(false) end, { desc = "Add PR comment" })
vim.keymap.set("n", "<leader>ocC", function() commands.add_comment_normal(false) end, { desc = "Add PR comment" })
vim.keymap.set("n", "<leader>ocv", commands.view_thread, { desc = "View PR thread" })
vim.keymap.set("n", "<leader>oca", function() commands.submit_review("APPROVE", "Approve") end, { desc = "Approve PR review" })
vim.keymap.set("n", "<leader>ocr", function() commands.submit_review("REQUEST_CHANGES", "Request changes") end, { desc = "Request PR changes" })
vim.keymap.set("n", "<leader>ocR", commands.reload, { desc = "Reload PR comments" })

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
