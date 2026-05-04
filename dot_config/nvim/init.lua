-- Bootstrap lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" } }, true, {})
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load core config before plugins
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.my")

-- Load all plugin specs from lua/plugins/*.lua
require("lazy").setup("plugins", {
  change_detection = { notify = false },
  ui = { border = "rounded" },
  performance = {
    rtp = {
      paths = { vim.env.VIMRUNTIME .. "/pack/dist/opt/nvim.undotree" },
    },
  },
})

-- Built-in opt packs (0.12+). lazy.nvim wipes packpath so :packadd can't find these;
-- we keep nvim.undotree in rtp via performance.rtp.paths above and source its plugin file.
vim.cmd.runtime("plugin/undotree.lua")
