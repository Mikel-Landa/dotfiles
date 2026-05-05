-- conform.nvim: formatter (null-ls replacement, community standard)
--
-- TO ADD A FORMATTER:
--   1. Add it to formatters_by_ft below
--   2. Run :MasonInstall <formatter-name>
--   Full list: https://github.com/stevearc/conform.nvim#formatters

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        rust = { "rustfmt" },
        go = { "gofmt" },
        sh = { "shfmt" },
      },
      -- Target 100-char line width (project config files override these)
      formatters = {
        stylua = { prepend_args = { "--column-width", "100" } },
        ruff_format = { prepend_args = { "--line-length", "100" } },
        prettier = { prepend_args = { "--print-width", "100" } },
        prettierd = { prepend_args = { "--print-width", "100" } },
      },
      -- Format on save (disable per-buffer with :ConformInfo)
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
  },
}
