-- Completion: blink.cmp (replaces nvim-cmp + sources)
--
-- Snippets via LuaSnip + friendly-snippets.
-- Default keymap preset: <C-n>/<C-p> select, <CR> confirm, <Tab> snippet-jump/select.

return {
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "*",
    dependencies = { "L3MON4D3/LuaSnip" },
    opts = {
      keymap = { preset = "default" },
      snippets = { preset = "luasnip" },
      sources = {
        default = { "lsp", "snippets", "path", "buffer" },
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        list = { selection = { preselect = false, auto_insert = false } },
      },
      signature = { enabled = true },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },
}
