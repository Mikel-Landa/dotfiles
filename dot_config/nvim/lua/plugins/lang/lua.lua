-- Lua: lua_ls + lazydev (workspace-aware globals for nvim config + Snacks/Lazy)
return {
  -- Treesitter parser already in core (lua + luadoc).

  -- Mason tools: stylua + lua-language-server
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "stylua", "lua-language-server" })
    end,
  },

  -- Conform formatter
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = { lua = { "stylua" } },
      formatters = {
        stylua = { prepend_args = { "--column-width", "100" } },
      },
    },
  },

  -- LSP server
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = { checkThirdParty = false },
              completion = { callSnippet = "Replace" },
              telemetry = { enable = false },
            },
          },
        },
      },
    },
  },

  -- lazydev: rich completion/hover for nvim config (Snacks, LazyVim, plenary, etc.)
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim/library", words = { "Snacks" } },
        { path = "lazy.nvim/library", words = { "LazyVim" } },
      },
    },
  },

  -- Wire lazydev completions into blink.cmp for Lua files.
  {
    "saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or {}
      vim.list_extend(opts.sources.default, { "lazydev" })
      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      }
    end,
  },
}
