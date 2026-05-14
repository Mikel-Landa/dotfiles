local opt = vim.opt
local g = vim.g

-- Disable unused providers (no Ruby/Perl/Node/Python plugins in use)
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_python3_provider = 0

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation (override per filetype via autocmd or ftplugin)
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smarttab = true
opt.smartindent = true
opt.autoindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.inccommand = "split" -- live preview :s substitutions in split window

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
opt.updatetime = 250 -- also drives CursorHold delay (diagnostic float hover)
opt.timeoutlen = 300 -- reduce chord ambiguity wait (default 1000ms causes cS flash delay)

opt.clipboard = "unnamedplus" -- sync with system clipboard

-- UI polish
opt.list = true -- render hidden whitespace
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.confirm = true -- dialog instead of error on :q with unsaved changes
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
