-- snacks: QoL suite — explorer, picker, notifier, statuscolumn, indent guides, lazygit
return {
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
            win = {
              list = {
                keys = {
                  ["<c-j>"] = false,
                  ["<c-k>"] = false,
                },
              },
              input = {
                keys = {
                  ["<c-j>"] = false,
                  ["<c-k>"] = false,
                },
              },
            },
          },
        },
      },
      rename = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      indent = {
        enabled = true,
        filter = function(buf)
          local ft = vim.bo[buf].filetype
          local indent_fts = { python = true, yaml = true, yml = true }
          return indent_fts[ft] == true
        end,
      },
      bufdelete = { enabled = true },
    },
    keys = {
      -- Explorer
      { "<leader>e", function() Snacks.explorer() end, desc = "Toggle file tree" },
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
}
