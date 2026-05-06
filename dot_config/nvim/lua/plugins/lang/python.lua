-- Python: pyright (types/hover) + ruff (lint/format diagnostics) + dap-python + venv-selector
return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_install = { "python", "ninja", "rst" } },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = { ensure_installed = { "pyright", "ruff", "debugpy" } },
  },

  -- ruff also formats (via LSP `textDocument/formatting`); conform's `ruff_format`
  -- and `ruff_organize_imports` formatters are kept for explicit `<leader>cf` runs.
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_format" },
      },
      formatters = {
        ruff_format = { prepend_args = { "--line-length", "100" } },
      },
    },
  },

  -- LSP servers
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },
        ruff = {
          cmd_env = { RUFF_TRACE = "messages" },
          init_options = { settings = { logLevel = "error" } },
          -- pyright owns hover; ruff hover is just rule code
          keys = function(client, _)
            client.server_capabilities.hoverProvider = false
          end,
        },
      },
    },
  },

  -- DAP adapter (debugpy)
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "python",
    keys = {
      { "<leader>dPt", function() require("dap-python").test_method() end, desc = "Debug Python: test method", ft = "python" },
      { "<leader>dPc", function() require("dap-python").test_class() end,  desc = "Debug Python: test class",  ft = "python" },
    },
    config = function()
      local mason_root = vim.fn.stdpath("data") .. "/mason"
      local debugpy = mason_root .. "/packages/debugpy/venv/bin/python"
      if vim.fn.executable(debugpy) == 1 then
        require("dap-python").setup(debugpy)
      else
        require("dap-python").setup("python")
      end
    end,
  },

  -- Virtualenv picker
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    dependencies = { "neovim/nvim-lspconfig", "mfussenegger/nvim-dap-python" },
    ft = "python",
    cmd = "VenvSelect",
    opts = {},
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select virtualenv", ft = "python" },
    },
  },
}
