-- Headless test bootstrap. Loads plenary from lazy's data dir and prepends the
-- config root so require("config.my...") resolves to lua/config/my/...
local config_root = vim.fn.getcwd()
vim.opt.runtimepath:prepend(config_root)

local plenary = vim.fn.stdpath("data") .. "/lazy/plenary.nvim"
if vim.fn.isdirectory(plenary) == 0 then
  io.stderr:write(("plenary.nvim not found at %s — run nvim once to let lazy.nvim install it\n"):format(plenary))
  vim.cmd("cq")
end
vim.opt.runtimepath:prepend(plenary)
vim.cmd("runtime plugin/plenary.vim")
