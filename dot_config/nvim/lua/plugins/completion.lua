-- Completion: blink.cmp (replaces nvim-cmp + sources)
--
-- Snippets via LuaSnip + friendly-snippets.
-- Default keymap preset: <C-n>/<C-p> select, <CR> confirm, <C-j>/<C-k> snippet-jump/select.

local function newline_skip_completion(motion)
  return function()
    local ok, blink = pcall(require, "blink.cmp")
    if ok and blink.is_visible() then blink.hide() end
    local keys = vim.api.nvim_replace_termcodes("<Esc>" .. motion, true, false, true)
    vim.api.nvim_feedkeys(keys, "n", false)
  end
end

vim.keymap.set("i", "<C-CR>",   newline_skip_completion("o"), { desc = "Newline below (skip completion)" })
vim.keymap.set("i", "<C-S-CR>", newline_skip_completion("O"), { desc = "Newline above (skip completion)" })

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
      keymap = {
        preset      = "default",
        ["<C-j>"]   = { "select_next", "snippet_forward", "fallback" },
        ["<C-k>"]   = { "select_prev", "snippet_backward", "fallback" },
        ["<Tab>"]   = { "fallback" },
        ["<S-Tab>"] = { "fallback" },
        ["<CR>"]    = { "accept", "fallback" },
      },
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
