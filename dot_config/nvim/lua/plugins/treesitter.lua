return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()
      require("nvim-treesitter").install({
        "lua", "vim", "vimdoc",
        "python", "typescript", "javascript", "tsx",
        "rust", "go", "c", "cpp",
        "json", "yaml", "toml",
        "html", "css",
        "bash", "markdown", "markdown_inline",
        "regex", "query",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { enable = true },
      })

      local sel = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      -- Select text objects
      local select_maps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      }
      for key, obj in pairs(select_maps) do
        vim.keymap.set({ "x", "o" }, key, function()
          sel.select_textobject(obj, "textobjects")
        end)
      end

      -- Move between text objects
      vim.keymap.set("n", "]f", function() move.goto_next_start("@function.outer", "textobjects") end)
      vim.keymap.set("n", "]c", function() move.goto_next_start("@class.outer", "textobjects") end)
      vim.keymap.set("n", "[f", function() move.goto_previous_start("@function.outer", "textobjects") end)
      vim.keymap.set("n", "[c", function() move.goto_previous_start("@class.outer", "textobjects") end)
    end,
  },
}
