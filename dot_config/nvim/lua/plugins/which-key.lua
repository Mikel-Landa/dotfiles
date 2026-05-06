-- which-key: leader-prefix popup with group labels
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>b", group = "buffer" },
        { "<leader>g", group = "git" },
        { "<leader>oc", group = "PR comments" },
        { "<leader>gt", group = "git toggles" },
        { "<leader>gv", group = "diffview" },
        { "<leader>l", group = "lsp" },
        { "<leader>d", group = "diagnostics" },
        { "<leader>x", group = "trouble" },
        { "<leader>q", group = "quickfix" },
        { "<leader>u", group = "ui toggles" },
        { "<leader>c", group = "code" },
        { "<leader>s", group = "search/noice" },
        { "<leader>sn", group = "noice" },
        { "<leader>w", group = "windows", proxy = "<C-w>" },
        { "<leader><tab>", group = "tabs" },
        { "<leader>o", group = "workflow" },
        { "<leader>p", group = "path" },
      },
    },
  },
}
