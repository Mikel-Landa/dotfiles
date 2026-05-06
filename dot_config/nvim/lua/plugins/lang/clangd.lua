-- C / C++: clangd + clangd_extensions + codelldb DAP
return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_install = { "c", "cpp" } },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = { ensure_installed = { "clangd", "codelldb" } },
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
          root_markers = {
            "compile_commands.json", "compile_flags.txt", "configure.ac",
            "Makefile", "configure.in", "config.h.in",
            "meson.build", "meson_options.txt", "build.ninja", ".git",
          },
          keys = function(_, bufnr)
            vim.keymap.set("n", "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>",
              { buffer = bufnr, desc = "LSP: Switch source/header" })
          end,
        },
      },
    },
  },

  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    opts = {
      inlay_hints = { inline = false },
      ast = {
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
    },
  },

  -- DAP: codelldb adapter + c/cpp configurations. Side-effect via opts so
  -- multiple lang files can register their own adapters without overriding each other.
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      if not dap.adapters.codelldb then
        local mason_root = vim.fn.stdpath("data") .. "/mason"
        local codelldb_bin = mason_root .. "/packages/codelldb/extension/adapter/codelldb"
        dap.adapters.codelldb = {
          type = "server",
          port = "${port}",
          executable = {
            command = vim.fn.executable(codelldb_bin) == 1 and codelldb_bin or vim.fn.exepath("codelldb"),
            args = { "--port", "${port}" },
          },
        }
      end
      for _, lang in ipairs({ "c", "cpp" }) do
        dap.configurations[lang] = dap.configurations[lang] or {}
        vim.list_extend(dap.configurations[lang], {
          {
            type = "codelldb",
            request = "launch",
            name = "Launch file",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
          },
          {
            type = "codelldb",
            request = "attach",
            name = "Attach to process",
            pid = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        })
      end
    end,
  },
}
