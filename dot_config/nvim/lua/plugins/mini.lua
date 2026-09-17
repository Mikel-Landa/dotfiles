-- mini.nvim: collection of editing micro-plugins
-- Commenting uses Neovim's native gc/gcc mappings.
return {
  {
    "echasnovski/mini.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Auto-close brackets and quotes
      require("mini.pairs").setup()

      -- Highlight trailing whitespace; formatters preserve language-specific meaning.
      require("mini.trailspace").setup()

      -- Icons (replaces nvim-web-devicons; mock its API for plugins that require it)
      require("mini.icons").setup()
      ---@diagnostic disable-next-line: undefined-global
      MiniIcons.mock_nvim_web_devicons()

      -- Surround (replaces nvim-surround; ys/ds/cs for muscle memory compatibility).
      -- These need flash.nvim's operator-pending `s` OFF (or {y,d,c}s would race);
      -- flash keeps `s` in n/x and relocates operator-pending jump to `z` (navigation.lua).
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
