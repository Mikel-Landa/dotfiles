-- Colorschemes + theme switcher (LazyVim-style).
--
-- All theme plugins are `lazy = true` — only the chosen one actually loads.
-- Lazy.nvim auto-detects installed colorschemes by scanning each plugin's
-- `colors/` dir, so `:colorscheme catppuccin-mocha` (driven by the picker
-- or the persisted-theme bootstrap) pulls in `catppuccin/nvim` on demand.
-- Switching schemes at runtime is cheap; the unused two never start up.
--
-- The actual `:colorscheme` call, persistence, and theme-agnostic highlight
-- tweaks live in `lua/config/my/theme.lua` (invoked from `init.lua` after
-- `lazy.setup`).

return {
  {
    "daedlock/matugen.nvim",
    lazy = true,
    opts = {
      colors_path = "~/.config/matugen/colors.json",
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
      flavour = "mocha",
      background = { dark = "mocha" },
      transparent_background = true,
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        mini = { enabled = true },
        neogit = true,
        noice = true,
        notify = true,
        snacks = { enabled = true },
        treesitter = true,
        treesitter_context = true,
        which_key = true,
        flash = true,
        fidget = true,
        rainbow_delimiters = true,
        render_markdown = true,
        markdown = true,
        dap = true,
        dap_ui = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
      },
    },
  },

  {
    "loctvl842/monokai-pro.nvim",
    lazy = true,
    opts = {
      transparent_background = true,
      terminal_colors = true,
      devicons = true,
      filter = "pro",
      day_night = { enable = false },
      inc_search = "background",
      background_clear = {
        "float_win",
        "toggleterm",
        "telescope",
        "renamer",
        "notify",
      },
      plugins = {
        bufferline = { underline_selected = false, underline_visible = false },
        indent_blankline = { context_highlight = "default", context_start_underline = false },
      },
    },
  },
}
