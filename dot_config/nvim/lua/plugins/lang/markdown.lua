-- Markdown: marksman LSP + render-markdown + markdown-preview + markdownlint-cli2 + markdown-toc
return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_install = { "markdown", "markdown_inline" } },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = {
      ensure_installed = {
        "marksman",
        "markdownlint-cli2",
        "markdown-toc",
        "prettierd",
      },
    },
  },

  -- Conform: prettier (format), markdownlint-cli2 (only if mdlint diagnostics present),
  -- markdown-toc (only if buffer contains the TOC marker).
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["markdown"] = { "prettierd", "prettier", "markdownlint-cli2", "markdown-toc" },
        ["markdown.mdx"] = { "prettierd", "prettier", "markdownlint-cli2", "markdown-toc" },
      },
      formatters = {
        ["markdown-toc"] = {
          condition = function(_, ctx)
            for _, l in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if l:find("<!%-%- toc %-%->") then return true end
            end
          end,
        },
        ["markdownlint-cli2"] = {
          condition = function(_, ctx)
            local diag = vim.diagnostic.get(ctx.buf)
            for _, d in ipairs(diag) do
              if d.source == "markdownlint" then return true end
            end
          end,
        },
      },
    },
  },

  -- Linter: markdownlint-cli2 via nvim-lint (diagnostics outside conform)
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint-cli2" },
        ["markdown.mdx"] = { "markdownlint-cli2" },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = { marksman = {} },
    },
  },

  -- Browser preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown preview",
      },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },

  -- In-buffer rendering (was in plugins/markdown.lua before refactor)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.icons",
    },
    opts = {
      file_types = { "markdown" },
      completions = { lsp = { enabled = true } },
    },
  },
}
