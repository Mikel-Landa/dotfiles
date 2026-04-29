-- colorscheme: catppuccin (mocha) + diagnostic undercurl tinting
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      integrations = {
        gitsigns = true,
      }
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")

      -- VSCode-style diagnostic underlines: undercurl, palette-driven.
      -- Requires terminal that supports undercurl (kitty, wezterm, alacritty 0.13+, foot,
      -- iTerm2 3.5+, tmux 3.4+ with `set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'`).
      local p = require("catppuccin.palettes").get_palette(opts.flavour)
      local set_hl = function(name, fg)
        vim.api.nvim_set_hl(0, name, { undercurl = true, sp = fg })
      end
      set_hl("DiagnosticUnderlineError", p.red)
      set_hl("DiagnosticUnderlineWarn", p.yellow)
      set_hl("DiagnosticUnderlineInfo", p.sky)
      set_hl("DiagnosticUnderlineHint", p.teal)
    end,
  },
}
