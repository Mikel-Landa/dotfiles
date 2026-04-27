return {
  -- Tmux/nvim pane navigation
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft", "TmuxNavigateDown",
      "TmuxNavigateUp", "TmuxNavigateRight",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>" },
    },
  },

  -- Colorscheme
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

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin" },
    opts = {
      options = {
        theme = "catppuccin-nvim",
        globalstatus = true,
        component_separators = "|",
        section_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- QoL: explorer, input, notifier, picker, rename, scope, scroll, statuscolumn
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      explorer = { enabled = true },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      picker = {
        enabled = true,
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
            exclude = { ".git", ".DS_Store", "node_modules" },
            follow_file = true,
            auto_close = false,
          },
        },
      },
      rename = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      lazygit = { enabled = true },
    },
    keys = {
      -- Explorer
      { "<leader>e", function() Snacks.explorer() end, desc = "Toggle file tree" },
      -- Lazygit
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gG", function() Snacks.lazygit.log() end, desc = "Lazygit log (cwd)" },
      -- Picker (git)
      { "<leader>gf", function() Snacks.picker.git_status() end, desc = "Git status (picker)" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git log" },
      { "<leader>gL", function() Snacks.picker.git_log_file() end, desc = "Git log (file)" },
      { "<leader>gB", function() Snacks.picker.git_branches() end, desc = "Git branches" },
      -- Notifier
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },
      { "<leader>fn", function() Snacks.picker.notifications() end, desc = "Notification history" },
    },
  },

  -- Git signs in gutter
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      signs_staged = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Navigation (fall back to native ]c/[c in diff mode)
        map("n", "]h", function()
          if vim.wo.diff then vim.cmd.normal({ "]c", bang = true })
          else gs.nav_hunk("next") end
        end, "Next hunk")
        map("n", "[h", function()
          if vim.wo.diff then vim.cmd.normal({ "[c", bang = true })
          else gs.nav_hunk("prev") end
        end, "Prev hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First hunk")

        -- Stage / reset
        map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>gs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage selection")
        map("v", "<leader>gr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset selection")
        map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")

        -- Inspect
        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line (full)")
        map("n", "<leader>gd", gs.diffthis, "Diff vs index")
        map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff vs HEAD~")

        -- Toggles
        map("n", "<leader>gtb", gs.toggle_current_line_blame, "Toggle inline blame")
        map("n", "<leader>gtd", gs.toggle_deleted, "Toggle deleted lines")
        map("n", "<leader>gtw", gs.toggle_word_diff, "Toggle word diff")

        -- Text object
        map({ "o", "x" }, "ih", gs.select_hunk, "inner hunk")
      end,
    },
  },

  -- Keybinding hint popup
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>b", group = "buffer" },
        { "<leader>g", group = "git" },
        { "<leader>gt", group = "git toggles" },
        { "<leader>l", group = "lsp" },
        { "<leader>d", group = "diagnostics" },
        { "<leader>x", group = "trouble" },
        { "<leader>q", group = "quickfix" },
        { "<leader>u", group = "ui toggles" },
        { "<leader>c", group = "code" },
        { "<leader>r", group = "rename/refactor" },
        { "<leader>s", group = "search/noice" },
        { "<leader>sn", group = "noice" },
      },
    },
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- Better UI for messages, cmdline, popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },
      routes = {
        {
          filter = { event = "msg_show", kind = "", find = "written" },
          opts = { skip = true },
        },
      },
    },
    keys = {
      { "<leader>sn", "", desc = "noice" },
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice last message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice history" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice all" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss all" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = { "i", "n", "s" } },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = { "i", "n", "s" } },
    },
  },
}
