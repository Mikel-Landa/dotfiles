-- Rust: rustaceanvim (replaces lspconfig rust_analyzer) + crates.nvim + codelldb DAP
return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      opts.ensure_install = opts.ensure_install or {}
      vim.list_extend(opts.ensure_install, { "rust", "ron" })
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "rust-analyzer", "codelldb" })
    end,
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = { rust = { "rustfmt", lsp_format = "fallback" } },
    },
  },

  -- crates.nvim — completion + actions in Cargo.toml
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = { crates = { enabled = true } },
      lsp = { enabled = true, actions = true, completion = true, hover = true },
    },
  },

  -- rustaceanvim wraps rust-analyzer; do NOT also enable rust_analyzer in lspconfig.
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    ft = { "rust" },
    opts = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = { enable = true },
            },
            checkOnSave = true,
            diagnostics = { enable = true },
            procMacro = { enable = true },
            files = {
              exclude = { ".direnv", ".git", ".jj", ".github", ".gitlab",
                "bin", "node_modules", "target", "venv", ".venv" },
              watcher = "client",
            },
          },
        },
      },
    },
    config = function(_, opts)
      -- Wire codelldb DAP adapter
      local mason_root = vim.fn.stdpath("data") .. "/mason"
      local codelldb_path = mason_root .. "/packages/codelldb/extension/adapter/codelldb"
      local lib_ext = vim.fn.has("mac") == 1 and "dylib" or "so"
      local liblldb_path = mason_root .. "/packages/codelldb/extension/lldb/lib/liblldb." .. lib_ext
      local cfg_ok, rust_cfg = pcall(require, "rustaceanvim.config")
      if cfg_ok and vim.fn.filereadable(codelldb_path) == 1 and vim.fn.filereadable(liblldb_path) == 1 then
        opts.dap = {
          adapter = rust_cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        }
      end
      vim.g.rustaceanvim = opts

      -- Buffer-local keymaps on rust files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "rust",
        callback = function(ev)
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          map("<leader>cR", function() vim.cmd.RustLsp("codeAction") end, "Rust code action")
          map("<leader>dr", function() vim.cmd.RustLsp("debuggables") end, "Rust debuggables")
        end,
      })
    end,
  },
}
