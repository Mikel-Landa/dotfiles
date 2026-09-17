-- conform.nvim base wiring. Lang files extend `opts.formatters_by_ft` via opts merging.
--
-- Tools install via mason-tool-installer (lsp.lua + lang files).
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    -- `<leader>cf` is bound globally in lua/config/keymaps.lua
    opts = {
      -- Base only — lang files extend.
      formatters_by_ft = {
        sh = { "shfmt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
  },
}
