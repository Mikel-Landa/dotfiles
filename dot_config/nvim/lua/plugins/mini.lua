-- mini.nvim: collection of editing micro-plugins
-- Replaces: Comment.nvim, nvim-surround, nvim-web-devicons, native <A-j/k> move maps
return {
  {
    "echasnovski/mini.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Auto-close brackets and quotes
      require("mini.pairs").setup()

      -- Underline all occurrences of word under cursor
      require("mini.cursorword").setup()

      -- Highlight + trim trailing whitespace on save
      require("mini.trailspace").setup()
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("mini_trailspace_trim", { clear = true }),
        callback = function()
          if vim.bo.filetype ~= "" and vim.bo.modifiable then
            ---@diagnostic disable-next-line: undefined-global
            MiniTrailspace.trim()
          end
        end,
      })

      -- Icons (replaces nvim-web-devicons; mock its API for plugins that require it)
      require("mini.icons").setup()
      ---@diagnostic disable-next-line: undefined-global
      MiniIcons.mock_nvim_web_devicons()

      -- Commenting (replaces Comment.nvim; same gc/gcc keymaps)
      require("mini.comment").setup()

      -- Surround (replaces nvim-surround; ys/ds/cs for muscle memory compatibility)
      require("mini.surround").setup({
        mappings = {
          add = "ys",
          delete = "ds",
          replace = "cs",
          find = "gsf",
          find_left = "gsF",
          highlight = "gsh",
          update_n_lines = "gsn",
        },
      })

      -- Move lines/selections with <A-j/k/h/l> (replaces native keymaps; adds horizontal move)
      require("mini.move").setup({
        mappings = {
          line_left  = "<A-h>",
          line_right = "<A-l>",
          line_down  = "<A-j>",
          line_up    = "<A-k>",
          left       = "<A-h>",
          right      = "<A-l>",
          down       = "<A-j>",
          up         = "<A-k>",
        },
      })
    end,
  },
}
