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
}

return {
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
      -- Displays LSP progress in bottom right
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
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

      -- Keymaps set only when LSP attaches to buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach_keymaps", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          local tb = require("telescope.builtin")
          map("gd", tb.lsp_definitions, "Go to definition")
          map("gr", tb.lsp_references, "References")
          map("gi", tb.lsp_implementations, "Go to implementation")
          map("gy", tb.lsp_type_definitions, "Type definition")
          map("K", vim.lsp.buf.hover, "Hover docs")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ls", tb.lsp_document_symbols, "Document symbols")
          map("<leader>lS", tb.lsp_workspace_symbols, "Workspace symbols")

          -- Inlay hints (Neovim 0.10+)
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
