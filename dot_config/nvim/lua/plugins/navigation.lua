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

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      -- `s` jump only in n/x — operator-pending `s` is freed for mini.surround's
      -- ys/ds/cs (see mini.lua). Operator-pending flash jump lives on `z` instead
      -- (`dz`/`cz`/`yz`); o-mode `z` has no builtin motion so normal `zz`/folds are safe.
      { "s",     mode = { "n", "x" },      function() require("flash").jump() end,              desc = "Flash" },
      { "z",     mode = { "o" },           function() require("flash").jump() end,              desc = "Flash (operator)" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
}
