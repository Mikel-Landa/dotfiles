return {
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>j", function() require("treesj").toggle() end, desc = "Toggle split/join block" },
    },
    opts = { use_default_keymaps = false },
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      user_default_options = {
        tailwind = true,
      },
    },
  },

  {
    "abecodes/tabout.nvim",
    event = "InsertEnter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "saghen/blink.cmp",
    },
    opts = {
      tabkey = "<Tab>",
      backwards_tabkey = "<S-Tab>",
      act_as_tab = true,
      completion = false,
    },
  },

  -- {
  {
    "sphamba/smear-cursor.nvim",
    opts = {},
    config = function(_, opts)
      require("smear_cursor").setup(opts)
      vim.api.nvim_create_autocmd("CmdlineEnter", {
        callback = function() require("smear_cursor").enabled = false end,
      })
      vim.api.nvim_create_autocmd("CmdlineLeave", {
        callback = function() require("smear_cursor").enabled = true end,
      })
    end,
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
}
