local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation (override per filetype via autocmd or ftplugin)
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.splitbelow = true
opt.splitright = true

-- Files
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.updatetime = 250  -- also drives CursorHold delay (diagnostic float hover)

-- Clipboard: sync with system clipboard
opt.clipboard = "unnamedplus"
