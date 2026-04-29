-- git: gitsigns gutter+hunks, diffview tabbed diff/file-history viewer
return {
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

  -- Tabbed diff & file history viewer
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
      "DiffviewFileHistory",
    },
    keys = {
      {
        "<leader>gg",
        function()
          local lib = require("diffview.lib")
          if lib.get_current_view() then
            vim.cmd("DiffviewClose")
          else
            vim.cmd("DiffviewOpen")
          end
        end,
        desc = "Toggle diffview",
      },
      { "<leader>gvo", "<cmd>DiffviewOpen<cr>",          desc = "Diffview open" },
      { "<leader>gvc", "<cmd>DiffviewClose<cr>",         desc = "Diffview close" },
      { "<leader>gvh", "<cmd>DiffviewFileHistory<cr>",   desc = "File history (repo)" },
      { "<leader>gvf", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current)" },
      { "<leader>gvt", "<cmd>DiffviewToggleFiles<cr>",   desc = "Toggle files panel" },
      { "<leader>gvr", "<cmd>DiffviewRefresh<cr>",       desc = "Refresh diffview" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        merge_tool = {
          layout = "diff3_mixed",
          disable_diagnostics = true,
        },
      },
    },
  },
}
