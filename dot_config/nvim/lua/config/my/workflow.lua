-- :Workflow — vim.ui.select dispatcher for remote PR/issue browsers.
-- Owns the <leader>o* root keymaps; sub-features (PR comments overlay) own
-- their own <leader>oc* subtree.
local actions = {
  { label = "󰊤  GitHub",    command = "Octo pr list" },
  { label = "  Bitbucket", command = "AtlasBitbucket" },
  { label = "󰌃  Jira",      command = "AtlasJira" },
}

vim.api.nvim_create_user_command("Workflow", function()
  vim.ui.select(actions, {
    prompt = "Workflow",
    format_item = function(item) return item.label end,
  }, function(choice)
    if choice then vim.cmd(choice.command) end
  end)
end, {})

vim.keymap.set("n", "<leader>oo", "<cmd>Workflow<cr>",        { desc = "Workflow picker" })
vim.keymap.set("n", "<leader>op", "<cmd>Octo pr list<cr>",    { desc = "GitHub PRs" })
vim.keymap.set("n", "<leader>oi", "<cmd>Octo issue list<cr>", { desc = "GitHub issues" })
vim.keymap.set("n", "<leader>oj", "<cmd>AtlasJira<cr>",       { desc = "Jira issues" })
vim.keymap.set("n", "<leader>ob", "<cmd>AtlasBitbucket<cr>",  { desc = "Bitbucket PRs" })
