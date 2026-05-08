-- :Workflow — vim.ui.select dispatcher for remote PR/issue browsers.
-- Owns the <leader>o* root keymaps; sub-features (PR comments overlay) own
-- their own <leader>oc* subtree.
local actions = {
  { label = "󰊤  GitHub PRs",      command = "AtlasPulls github" },
  { label = "  Bitbucket PRs",   command = "AtlasPulls bitbucket" },
  { label = "󰌃  Jira issues",     command = "AtlasIssues jira" },
  { label = "󰊤  GitHub issues",   command = "Octo issue list" },
}

vim.api.nvim_create_user_command("Workflow", function()
  vim.ui.select(actions, {
    prompt = "Workflow",
    format_item = function(item) return item.label end,
  }, function(choice)
    if choice then vim.cmd(choice.command) end
  end)
end, {})

-- Detect PR host from git remotes; first match wins. nil = unknown.
local function detect_pr_host()
  local out = vim.fn.systemlist({ "git", "remote", "-v" })
  if vim.v.shell_error ~= 0 then return nil end
  for _, line in ipairs(out) do
    if line:find("github%.com") then return "github" end
    if line:find("bitbucket%.org") then return "bitbucket" end
  end
  return nil
end

local function open_prs()
  local host = detect_pr_host()
  if host then
    vim.cmd("AtlasPulls " .. host)
  else
    vim.notify("No GitHub/Bitbucket remote — opening picker", vim.log.levels.WARN)
    vim.cmd("Workflow")
  end
end

-- Issues: GitHub repo → Octo (atlas has no GitHub-issues provider); else → Jira.
local function open_issues()
  if detect_pr_host() == "github" then
    vim.cmd("Octo issue list")
  else
    vim.cmd("AtlasIssues jira")
  end
end

vim.keymap.set("n", "<leader>oo", "<cmd>Workflow<cr>", { desc = "Workflow picker" })
vim.keymap.set("n", "<leader>op", open_prs,            { desc = "PRs (auto: github/bitbucket)" })
vim.keymap.set("n", "<leader>oi", open_issues,         { desc = "Issues (auto: github/jira)" })
