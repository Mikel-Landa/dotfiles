-- :Workflow — vim.ui.select dispatcher for remote PR/issue browsers.
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
