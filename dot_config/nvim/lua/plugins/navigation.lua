-- navigation: tmux/nvim pane navigation
return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft", "TmuxNavigateDown",
      "TmuxNavigateUp", "TmuxNavigateRight",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>",  mode = { "n", "i", "t" }, desc = "Navigate left" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>",  mode = { "n", "i", "t" }, desc = "Navigate down" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>",    mode = { "n", "i", "t" }, desc = "Navigate up" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", mode = { "n", "i", "t" }, desc = "Navigate right" },
    },
  },
}
