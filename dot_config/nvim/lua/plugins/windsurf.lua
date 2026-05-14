-- windsurf.nvim (Exafunction/windsurf.nvim): AI inline completions (Codeium backend).
-- Virtual text ghost-text + blink.cmp menu entry.
-- Auth: :Codeium Auth (browser flow, one-time).
return {
  {
    "Exafunction/windsurf.nvim",
    main = "codeium",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      enable_cmp_source = false, -- using blink.cmp, not nvim-cmp
      virtual_text = {
        enabled = true,
        key_bindings = {
          accept = "<M-CR>",
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
    },
  },

  {
    "saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or {}
      vim.list_extend(opts.sources.default, { "codeium" })
      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.codeium = {
        name = "codeium",
        module = "codeium.blink",
        async = true,
        score_offset = 100,
      }
    end,
  },
}
