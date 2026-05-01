-- obsidian.nvim: Obsidian-style markdown notes with links, backlinks, templates, daily notes
return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      workspaces = {
        { name = "notes", path = "~/Notes" },  -- adjust to your vault path
      },
      picker = { name = "snacks" },
      completion = { nvim_cmp = false, min_chars = 2 },
      follow_url_func = function(url)
        vim.fn.jobstart({ "xdg-open", url })
      end,
      ui = {
        enable = true,
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
        },
      },
    },
    keys = {
      { "<leader>on", "<cmd>ObsidianNew<cr>",         desc = "New note" },
      { "<leader>oo", "<cmd>ObsidianOpen<cr>",        desc = "Open in Obsidian app" },
      { "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", desc = "Find note" },
      { "<leader>og", "<cmd>ObsidianSearch<cr>",      desc = "Grep notes" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>",   desc = "Backlinks" },
      { "<leader>ot", "<cmd>ObsidianTags<cr>",        desc = "Tags" },
      { "<leader>ol", "<cmd>ObsidianLinks<cr>",       desc = "Links in note" },
      { "<leader>od", "<cmd>ObsidianDailies<cr>",     desc = "Daily notes" },
      { "<leader>oI", "<cmd>ObsidianPasteImg<cr>",    desc = "Paste image" },
    },
  },
}
