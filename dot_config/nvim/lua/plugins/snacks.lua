-- snacks: QoL suite — explorer, picker, notifier, statuscolumn, indent guides, lazygit

-- Filetypes where indent guides render by default. Per-buffer override via
-- `<leader>ui` (sets `b:snacks_indent_show`).
local indent_allowlist = {
  python = true, yaml = true,
  html = true, json = true, jsonc = true, toml = true,
}

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
        win = {
          input = {
            wo = { winhighlight = "Normal:Normal,NormalFloat:Normal,FloatBorder:FloatBorder,FloatTitle:FloatTitle" },
          },
          list = { wo = { winhighlight = "Normal:Normal,NormalFloat:Normal,FloatBorder:FloatBorder" } },
          preview = { wo = { winhighlight = "Normal:Normal,NormalFloat:Normal,FloatBorder:FloatBorder,FloatTitle:FloatTitle" } },
        },
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
            exclude = { ".git", ".DS_Store", "node_modules" },
            follow_file = true,
            auto_close = false,
            win = {
              list = {
                wo = { winhighlight = "Normal:Normal,NormalFloat:Normal,FloatBorder:FloatBorder" },
                keys = {
                  ["<c-j>"] = false,
                  ["<c-k>"] = false,
                },
              },
              input = {
                wo = { winhighlight = "Normal:Normal,NormalFloat:Normal,FloatBorder:FloatBorder,FloatTitle:FloatTitle" },
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
        indent = { char = "│", hl = "SnacksIndent" },
        scope = { char = "│", hl = "SnacksIndentScope" },
        chunk = { enabled = false },
        animate = { enabled = false },
        filter = function(buf)
          if not vim.api.nvim_buf_is_valid(buf) then return false end
          if vim.bo[buf].buftype ~= "" then return false end
          local override = vim.b[buf].snacks_indent_show
          if override ~= nil then return override end
          return indent_allowlist[vim.bo[buf].filetype] == true
        end,
      },
      terminal = { enabled = true },
      bufdelete = { enabled = true },
      gitbrowse = { enabled = true },
    },
    keys = {
      -- Explorer
      { "<leader>e", function() Snacks.explorer() end, desc = "Toggle file tree" },
      -- Picker (git)
      { "<leader>gf", function() Snacks.picker.git_status() end, desc = "Git status (picker)" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git log" },
      { "<leader>gL", function() Snacks.picker.git_log_file() end, desc = "Git log (file)" },
      { "<leader>gB", function() Snacks.picker.git_branches() end, desc = "Git branches" },
      { "<leader>gO", function() Snacks.gitbrowse() end, mode = { "n", "v" }, desc = "Open file in browser" },
      -- Terminal
      { "<leader>ut", function() Snacks.terminal.toggle() end, desc = "Toggle terminal" },
      -- Notifier
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },
      { "<leader>fn", function() Snacks.picker.notifications() end, desc = "Notification history" },
      -- Indent guides toggle (per buffer)
      {
        "<leader>ui",
        function()
          local buf = vim.api.nvim_get_current_buf()
          local cur = vim.b[buf].snacks_indent_show
          if cur == nil then cur = indent_allowlist[vim.bo[buf].filetype] == true end
          vim.b[buf].snacks_indent_show = not cur
          vim.cmd("redraw!")
        end,
        desc = "Toggle indent guides (buffer)",
      },
    },
  },
}
