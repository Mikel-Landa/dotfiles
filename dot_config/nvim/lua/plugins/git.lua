-- git: gitsigns gutter+hunks, codediff side-by-side diff/file-history viewer
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

  -- Side-by-side diff & file history viewer (VSCode-style)
  {
    "esmuellert/codediff.nvim",
    cmd = { "CodeDiff" },
    keys = {
      {
        "<leader>gg",
        function()
          local lifecycle = require("codediff.ui.lifecycle")
          if lifecycle.get_session(vim.api.nvim_get_current_tabpage()) then
            lifecycle.cleanup()
          else
            vim.cmd("CodeDiff")
          end
        end,
        desc = "Toggle codediff",
      },
      {
        "<leader>gG",
        function()
          local lifecycle = require("codediff.ui.lifecycle")
          if lifecycle.get_session(vim.api.nvim_get_current_tabpage()) then
            lifecycle.cleanup()
            return
          end

          local function run(cmd)
            local r = vim.system(cmd, { text = true }):wait()
            return r and r.code == 0 and vim.trim(r.stdout) or nil
          end

          local base = run({ "git", "symbolic-ref", "--short", "refs/remotes/origin/HEAD" })
          if not base then
            for _, candidate in ipairs({ "origin/main", "origin/master", "origin/develop", "origin/trunk" }) do
              if run({ "git", "rev-parse", "--verify", candidate }) then
                base = candidate; break
              end
            end
          end
          if not base then
            vim.notify("Could not resolve origin's default branch. Run: git remote set-head origin -a", vim.log.levels.WARN)
            return
          end
          vim.cmd(("CodeDiff %s...HEAD"):format(base))
        end,
        desc = "Toggle codediff vs origin default branch (PR overlay)",
      },
      { "<leader>gvo", "<cmd>CodeDiff<cr>",            desc = "CodeDiff open" },
      {
        "<leader>gvc",
        function() require("codediff.ui.lifecycle").cleanup() end,
        desc = "CodeDiff close",
      },
      { "<leader>gvh", "<cmd>CodeDiff history<cr>",    desc = "File history (repo)" },
      { "<leader>gvf", "<cmd>CodeDiff history %<cr>",  desc = "File history (current)" },
    },
    opts = {},
  },
}
