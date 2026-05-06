-- LSP + Mason (auto-installer for language servers)
--
-- TO ADD A NEW LANGUAGE:
--   1. Add server name to `servers` table below
--   2. Optionally add custom settings in the server's value table
--   3. Run :MasonInstall <server-name> or let mason-lspconfig handle it automatically
--   Full server list: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers

local servers = {
  -- Lua
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },
  -- Python
  pyright = {},
  -- TypeScript / JavaScript
  ts_ls = {},
  -- Rust
  rust_analyzer = {},
  -- Go
  gopls = {},
  -- C / C++
  clangd = {},
  -- JSON / YAML / HTML / CSS (all via vscode-langservers-extracted).
  -- Schemas injected lazily in nvim-lspconfig config below (SchemaStore.nvim).
  jsonls = {},
  yamlls = {},
  html = {},
  cssls = {},
  -- Bash
  bashls = {},
  -- toml (tombi: TOML 1.1 support; taplo is unmaintained and 1.0-only)
  tombi = {}
}

return {
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },

  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = { ui = { border = "rounded" } },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = vim.tbl_keys(servers),
      automatic_enable = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "saghen/blink.cmp",
      "b0o/SchemaStore.nvim",
    },
    config = function()
      -- Diagnostic display: underlines on, virtual_text off (float on CursorHold replaces it),
      -- signs in gutter, sorted by severity. Set here so it applies only when LSP loads.
      vim.diagnostic.config({
        underline = true,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        signs = true,
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
      })

      -- Inject SchemaStore schemas into json/yaml servers
      servers.jsonls = vim.tbl_deep_extend("force", servers.jsonls, {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })
      servers.yamlls = vim.tbl_deep_extend("force", servers.yamlls, {
        settings = {
          yaml = {
            schemaStore = { enable = false, url = "" },
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      })

      -- Toggle diagnostics globally
      local diag_enabled = true
      vim.keymap.set("n", "<leader>ud", function()
        diag_enabled = not diag_enabled
        vim.diagnostic.enable(diag_enabled)
        vim.notify(diag_enabled and "Diagnostics on" or "Diagnostics off", vim.log.levels.INFO)
      end, { desc = "Toggle diagnostics" })

      -- Keymaps set only when LSP attaches to buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach_keymaps", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", function() Snacks.picker.lsp_definitions() end, "Go to definition")
          map("gr", function() Snacks.picker.lsp_references() end, "References")
          map("gi", function() Snacks.picker.lsp_implementations() end, "Go to implementation")
          map("gy", function() Snacks.picker.lsp_type_definitions() end, "Type definition")
          map("K", vim.lsp.buf.hover, "Hover docs")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>lr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ls", function() Snacks.picker.lsp_symbols() end, "Document symbols")
          map("<leader>lS", function() Snacks.picker.lsp_workspace_symbols() end, "Workspace symbols")

          -- Go to definition in vertical split
          map("<leader>lv", function()
            vim.cmd("vsplit")
            Snacks.picker.lsp_definitions()
          end, "Definition in vsplit")

          -- Organize imports + format (TypeScript only)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.name == "ts_ls" then
            vim.keymap.set("n", "<leader>co", function()
              vim.lsp.buf.execute_command({
                command = "_typescript.organizeImports",
                arguments = { vim.api.nvim_buf_get_name(0) },
              })
              require("conform").format({ async = true, lsp_format = "fallback" })
            end, { buffer = event.buf, desc = "LSP: Organize imports + format" })
          end

          -- Inlay hints (Neovim 0.10+)
          ---@diagnostic disable-next-line: redefined-local
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(false, { bufnr = event.buf })
            map("<leader>uh", function()
              vim.lsp.inlay_hint.enable(
                not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }),
                { bufnr = event.buf }
              )
            end, "Toggle inlay hints")
          end
        end,
      })

      -- Capabilities from blink.cmp
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      -- Set per-server custom config
      for server, cfg in pairs(servers) do
        if next(cfg) ~= nil then
          vim.lsp.config(server, cfg)
        end
      end

      -- Enable all servers
      vim.lsp.enable(vim.tbl_keys(servers))
    end,
  },
}
