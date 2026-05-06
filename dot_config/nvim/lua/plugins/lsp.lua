-- LSP base wiring.
--
-- Per-language LSP servers (and their settings) live in `lua/plugins/lang/<name>.lua`.
-- Each lang file adds its server to `opts.servers` here via lazy.nvim's opts merging.
-- Lang files also add tools (formatters/linters/DAP adapters) via the mason-tool-installer
-- spec below (opts.ensure_installed merges across specs).
--
-- This file owns: mason, mason-lspconfig, mason-tool-installer, nvim-lspconfig core
-- (capabilities, diagnostic config, LspAttach keymaps).
--
-- Base servers configured here are language-light (json, yaml, html, css, bash, etc.) —
-- anything richer (pyright, vtsls, gopls, clangd, lua_ls) lives in its lang file.

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
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- Base tools (always installed). Lang files extend via opts.ensure_installed.
      ensure_installed = {
        -- Base LSPs (matches `servers` in nvim-lspconfig spec below)
        "json-lsp",
        "yaml-language-server",
        "html-lsp",
        "css-lsp",
        "bash-language-server",
        "tombi",
        -- Base formatters
        "shfmt",
      },
      run_on_start = true,
      start_delay = 3000,
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      -- Server installs are handled by mason-tool-installer. We enable servers
      -- ourselves in nvim-lspconfig's config (only the ones listed in opts.servers),
      -- so disable mason-lspconfig's auto-enable to avoid starting orphan servers
      -- that may already be installed (e.g. a stale `ts_ls` after the vtsls switch).
      ensure_installed = {},
      automatic_enable = false,
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "saghen/blink.cmp",
      "b0o/SchemaStore.nvim",
    },
    opts = {
      -- Base servers — lang files merge their servers in here.
      -- Settings for json/yaml are filled out by SchemaStore in `setup` below.
      servers = {
        jsonls = {},
        yamlls = {
          capabilities = {
            textDocument = {
              foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
            },
          },
        },
        html = {},
        cssls = {},
        bashls = {},
        -- tombi: TOML 1.1 support; taplo is unmaintained and 1.0-only.
        tombi = {},
      },
    },
    config = function(_, opts)
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

      local servers = opts.servers or {}

      -- SchemaStore injection for json/yaml
      servers.jsonls = vim.tbl_deep_extend("force", servers.jsonls or {}, {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
            format = { enable = true },
          },
        },
      })
      servers.yamlls = vim.tbl_deep_extend("force", servers.yamlls or {}, {
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            keyOrdering = false,
            format = { enable = true },
            validate = true,
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

      -- LspAttach keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach_keymaps", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", function() Snacks.picker.lsp_definitions() end, "Go to definition")
          map("K", vim.lsp.buf.hover, "Hover docs")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>lr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ls", function() Snacks.picker.lsp_symbols() end, "Document symbols")
          map("<leader>lS", function() Snacks.picker.lsp_workspace_symbols() end, "Workspace symbols")

          map("<leader>lv", function()
            vim.cmd("vsplit")
            Snacks.picker.lsp_definitions()
          end, "Definition in vsplit")

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- Per-server on_attach hook (lang files can set servers[name].keys to a function
          -- receiving (client, bufnr) for extra mappings)
          if client and servers[client.name] and type(servers[client.name].keys) == "function" then
            servers[client.name].keys(client, event.buf)
          end

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

      -- clangd needs utf-16 offset encoding
      vim.lsp.config("clangd", {
        capabilities = vim.tbl_deep_extend("force", capabilities, { offsetEncoding = { "utf-16" } }),
      })

      -- Apply per-server config (skip the `keys` field — it's our own LspAttach hook)
      for server, cfg in pairs(servers) do
        local clean = vim.deepcopy(cfg)
        clean.keys = nil
        if next(clean) ~= nil then
          vim.lsp.config(server, clean)
        end
      end

      vim.lsp.enable(vim.tbl_keys(servers))
    end,
  },
}
