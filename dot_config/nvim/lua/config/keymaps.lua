local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- Resize windows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { silent = true, desc = "Resize up" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { silent = true, desc = "Resize down" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { silent = true, desc = "Resize left" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { silent = true, desc = "Resize right" })

-- Move lines in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered when jumping
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

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

-- Buffer navigation
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Format
map({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format" })

-- Save
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- System clipboard (explicit sync, nvim clipboard stays separate)
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
map("n", "<C-S-V>", '"+p', { desc = "Paste from system clipboard" })

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
