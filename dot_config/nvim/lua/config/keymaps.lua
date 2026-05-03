local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- Resize windows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { silent = true, desc = "Resize up" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { silent = true, desc = "Resize down" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { silent = true, desc = "Resize left" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { silent = true, desc = "Resize right" })

-- Window prefix: <leader>w replaces <C-w> (all default window subkeys still work)
map("n", "<leader>w", "<C-w>", { remap = true, desc = "Windows" })
map("n", "<leader>-", "<C-w>s", { desc = "Split window below", remap = true })
map("n", "<leader>|", "<C-w>v", { desc = "Split window right", remap = true })
map("n", "<leader>w-", "<C-w>s", { desc = "Split window below", remap = true })
map("n", "<leader>w|", "<C-w>v", { desc = "Split window right", remap = true })
map("n", "<leader>wd", "<C-w>c", { desc = "Delete window", remap = true })

-- Tabs
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>",     { desc = "New tab" })
map("n", "<leader><tab>]",     "<cmd>tabnext<cr>",    { desc = "Next tab" })
map("n", "<leader><tab>[",     "<cmd>tabprevious<cr>",{ desc = "Prev tab" })
map("n", "<leader><tab>d",     "<cmd>tabclose<cr>",   { desc = "Close tab" })
map("n", "<leader><tab>o",     "<cmd>tabonly<cr>",    { desc = "Close other tabs" })
map("n", "<leader><tab>f",     "<cmd>tabfirst<cr>",   { desc = "First tab" })
map("n", "<leader><tab>l",     "<cmd>tablast<cr>",    { desc = "Last tab" })

-- Keep cursor centered when jumping
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })

-- Don't yank on paste in visual mode
map("v", "p", '"_dP', { desc = "Paste without yank" })

-- Fuzzy finder (snacks.picker)
map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find files" })
map("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "Live grep" })
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "Help tags" })
map("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent files" })
map("n", "<leader>fk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
map("n", "<leader>f/", function() Snacks.picker.lines() end, { desc = "Lines (current buffer)" })
map("n", "<leader>fd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
map("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Config files" })

-- Buffer navigation (cycle keys [b/]b/<S-h>/<S-l> registered by bufferline plugin)
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to other buffer" })
map("n", "<leader>`",  "<cmd>e #<cr>", { desc = "Switch to other buffer" })
map("n", "<leader>bd", function() Snacks.bufdelete() end,         { desc = "Delete buffer" })
map("n", "<leader>bD", "<cmd>bdelete<cr>",                         { desc = "Delete buffer + window" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end,    { desc = "Delete other buffers" })

-- Format
map({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format" })

-- Save
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Exit terminal mode (more discoverable than <C-\><C-n>)
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- System clipboard (explicit sync, nvim clipboard stays separate)
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
map("n", "<C-S-V>", '"+p', { desc = "Paste from system clipboard" })

-- Copy absolute file path to clipboard
map("n", "<leader>pa", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path, vim.log.levels.INFO)
end, { desc = "Copy absolute path" })

-- Delete without yanking (black-hole register)
map({ "n", "v" }, "<leader>D", '"_d', { desc = "Delete without yank" })

-- Join lines keeping cursor position
map("n", "J", "mzJ`z", { desc = "Join lines (cursor fixed)" })

-- Undo tree (built-in nvim.undotree, 0.12+)
map("n", "<leader>uu", "<cmd>Undotree<cr>", { desc = "Open undo tree" })

-- Toggle word wrap (current buffer)
map("n", "<leader>uw", function()
  vim.opt_local.wrap = not vim.wo.wrap
  vim.opt_local.linebreak = vim.wo.wrap
  vim.notify("Wrap: " .. (vim.wo.wrap and "on" or "off"), vim.log.levels.INFO)
end, { desc = "Toggle word wrap" })

-- Diagnostics
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev diagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })

-- Quickfix list (unimpaired-style nav)
-- Bulk edit across qf entries: :cdo s/foo/bar/g | update
map("n", "[q", "<cmd>cprevious<cr>zz",  { desc = "Prev quickfix" })
map("n", "]q", "<cmd>cnext<cr>zz",      { desc = "Next quickfix" })
map("n", "[Q", "<cmd>cfirst<cr>zz",     { desc = "First quickfix" })
map("n", "]Q", "<cmd>clast<cr>zz",      { desc = "Last quickfix" })
map("n", "[<C-q>", "<cmd>cpfile<cr>zz", { desc = "Prev quickfix file" })
map("n", "]<C-q>", "<cmd>cnfile<cr>zz", { desc = "Next quickfix file" })

-- Location list (unimpaired-style nav)
map("n", "[l", "<cmd>lprevious<cr>zz",  { desc = "Prev loclist" })
map("n", "]l", "<cmd>lnext<cr>zz",      { desc = "Next loclist" })
map("n", "[L", "<cmd>lfirst<cr>zz",     { desc = "First loclist" })
map("n", "]L", "<cmd>llast<cr>zz",      { desc = "Last loclist" })
map("n", "[<C-l>", "<cmd>lpfile<cr>zz", { desc = "Prev loclist file" })
map("n", "]<C-l>", "<cmd>lnfile<cr>zz", { desc = "Next loclist file" })

-- Quickfix manage
map("n", "<leader>qo", "<cmd>copen<cr>",  { desc = "Open quickfix" })
map("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix" })
map("n", "<leader>qx", function() vim.fn.setqflist({}, "r") end, { desc = "Clear quickfix" })
map("n", "<leader>q[", "<cmd>colder<cr>", { desc = "Older quickfix list" })
map("n", "<leader>q]", "<cmd>cnewer<cr>", { desc = "Newer quickfix list" })

-- Loclist manage
map("n", "<leader>lo", "<cmd>lopen<cr>",  { desc = "Open loclist" })
map("n", "<leader>lc", "<cmd>lclose<cr>", { desc = "Close loclist" })
