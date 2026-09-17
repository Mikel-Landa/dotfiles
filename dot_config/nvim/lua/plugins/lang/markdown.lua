-- Markdown: marksman LSP + render-markdown + markdown-preview + markdownlint-cli2 + markdown-toc
return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      opts.ensure_install = opts.ensure_install or {}
      vim.list_extend(opts.ensure_install, { "markdown", "markdown_inline" })
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "marksman",
        "markdownlint-cli2",
        "markdown-toc",
        "prettierd",
      })
    end,
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
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("markdown_diagnostics", { clear = true }),
        pattern = { "markdown", "markdown.mdx" },
        callback = function(event)
          vim.diagnostic.enable(false, { bufnr = event.buf })
          vim.keymap.set("n", "<leader>ud", function()
            local filter = { bufnr = event.buf }
            local enabled = not vim.diagnostic.is_enabled(filter)
            vim.diagnostic.enable(enabled, filter)
            vim.notify(enabled and "Diagnostics on" or "Diagnostics off", vim.log.levels.INFO)
          end, { buffer = event.buf, desc = "Toggle diagnostics" })
        end,
      })
    end,
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
      "echasnovski/mini.nvim",
    },
    keys = {
      { "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown rendering" },
    },
    opts = {
      enabled = false,
      file_types = { "markdown" },
      completions = { lsp = { enabled = true } },
    },
  },
}
