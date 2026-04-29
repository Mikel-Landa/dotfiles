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
        ["af"] = { "@function.outer", "Outer function" },
        ["if"] = { "@function.inner", "Inner function" },
        ["ac"] = { "@class.outer",    "Outer class" },
        ["ic"] = { "@class.inner",    "Inner class" },
        ["aa"] = { "@parameter.outer","Outer argument" },
        ["ia"] = { "@parameter.inner","Inner argument" },
      }
      for key, val in pairs(select_maps) do
        vim.keymap.set({ "x", "o" }, key, function()
          sel.select_textobject(val[1], "textobjects")
        end, { desc = val[2] })
      end

      -- Move between text objects
      vim.keymap.set("n", "]f", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "Next function" })
      vim.keymap.set("n", "]C", function() move.goto_next_start("@class.outer", "textobjects") end,    { desc = "Next class" })
      vim.keymap.set("n", "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Prev function" })
      vim.keymap.set("n", "[C", function() move.goto_previous_start("@class.outer", "textobjects") end,    { desc = "Prev class" })
    end,
  },
}
