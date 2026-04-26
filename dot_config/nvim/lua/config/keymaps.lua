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

-- Telescope (fuzzy finder)
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })

-- File explorer
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file tree" })

-- Buffer navigation
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Format
map({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format" })

-- Diagnostics
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev diagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
