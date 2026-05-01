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
opt.timeoutlen = 300  -- reduce chord ambiguity wait (default 1000ms causes cS flash delay)

-- Clipboard: keep nvim clipboard separate from system (use keymaps for explicit sync)

-- Column guide + UI polish
opt.colorcolumn = "100"
opt.fillchars = { eob = " " }
opt.pumheight = 10
opt.pumblend = 10
opt.ttimeoutlen = 50
opt.showmatch = true
opt.autoread = true
opt.iskeyword:append("-")
opt.diffopt:append("linematch:60")

-- Treesitter-based folding (foldlevel 99 = all folds open by default)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
