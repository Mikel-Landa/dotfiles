-- Treesitter base wiring. Lang files extend `opts.ensure_install` via opts merging.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    opts = {
      -- Base parsers (language-agnostic / shell / vim / config formats).
      -- Lang files add their own (e.g. python, rust, go) via opts merging.
      ensure_install = {
        "bash",
        "diff",
        "git_config",
        "gitcommit",
        "gitignore",
        "lua",
        "luadoc",
        "query",
        "regex",
        "vim",
        "vimdoc",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup()
      -- Dedupe in case multiple specs add the same parser
      local seen, parsers = {}, {}
      for _, p in ipairs(opts.ensure_install or {}) do
        if not seen[p] then seen[p] = true; parsers[#parsers + 1] = p end
      end
      require("nvim-treesitter").install(parsers)

      -- main branch does not auto-attach. Start treesitter per buffer on
      -- FileType. If the parser is missing (still installing or unsupported
      -- ft), pcall swallows the error so the buffer stays usable.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("ts_start", { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
          if not lang then return end
          if not pcall(vim.treesitter.language.add, lang) then return end
          pcall(vim.treesitter.start, ev.buf, lang)
          vim.bo[ev.buf].syntax = "ON" -- keep vim regex syntax as fallback for unhandled groups
          vim.wo.foldmethod = "expr"
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo.foldenable = false
        end,
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

      local select_maps = {
        ["af"] = { "@function.outer", "Outer function" },
        ["if"] = { "@function.inner", "Inner function" },
        ["ac"] = { "@class.outer", "Outer class" },
        ["ic"] = { "@class.inner", "Inner class" },
        ["aa"] = { "@parameter.outer", "Outer argument" },
        ["ia"] = { "@parameter.inner", "Inner argument" },
      }
      for key, val in pairs(select_maps) do
        vim.keymap.set({ "x", "o" }, key, function()
          sel.select_textobject(val[1], "textobjects")
        end, { desc = val[2] })
      end

      vim.keymap.set("n", "]f", function() move.goto_next_start("@function.outer", "textobjects") end,
        { desc = "Next function" })
      vim.keymap.set("n", "]C", function() move.goto_next_start("@class.outer", "textobjects") end,
        { desc = "Next class" })
      vim.keymap.set("n", "[f", function() move.goto_previous_start("@function.outer", "textobjects") end,
        { desc = "Prev function" })
      vim.keymap.set("n", "[C", function() move.goto_previous_start("@class.outer", "textobjects") end,
        { desc = "Prev class" })
    end,
  },
}
