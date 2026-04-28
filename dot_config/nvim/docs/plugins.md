# Plugins

Quick reference for every installed plugin: what it does and how to drive it.

Leader = `<Space>`. `gd`-style maps work in normal mode unless noted.

---

## UI

### catppuccin/nvim — Colorscheme
Mocha flavour. Diagnostic underlines use the palette's red/yellow/sky/teal.

### nvim-lualine/lualine.nvim — Statusline
Shows mode, branch, diff, diagnostics, file path, encoding, filetype, progress, location. Global statusline (one bar across splits).

### folke/which-key.nvim — Keybinding hints
After pressing leader, wait briefly to see grouped popup of all leader-prefixed keys.

### lukas-reineke/indent-blankline.nvim — Indent guides
Vertical lines on indented blocks. Passive.

### akinsho/bufferline.nvim — Buffer tabs
Top bar showing open buffers as tab-like entries. LSP diagnostics shown per buffer. Snacks explorer offset reserves the explorer column. See [Buffers](keymaps.md#buffers) for full keymaps. Highlights: `<S-h>`/`<S-l>` cycle, `<leader>bp` pin, `<leader>br/bl` delete to one side.

### j-hui/fidget.nvim — LSP progress notifications
Spinner in bottom-right while LSP servers index/load.

### christoomey/vim-tmux-navigator — Tmux pane navigation
Move between Neovim splits and tmux panes seamlessly.

| Key | Action |
|---|---|
| `<C-h>` | Left |
| `<C-j>` | Down |
| `<C-k>` | Up |
| `<C-l>` | Right |

### folke/snacks.nvim — Explorer
Toggle with `<leader>e`. Inside the tree:

| Key | Action |
|---|---|
| `<CR>` | Open file / toggle dir |
| `a` | Add file (end with `/` for dir) |
| `d` | Delete |
| `r` | Rename (LSP-aware via `Snacks.rename`) |
| `c` | Copy |
| `m` | Move |
| `y` | Yank path |
| `H` | Toggle hidden |
| `I` | Toggle ignored |
| `?` | Help |
| `q` / `<Esc>` | Close |

---

## Search & navigation

### nvim-telescope/telescope.nvim — Fuzzy finder

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep across project |
| `<leader>fb` | Open buffers |
| `<leader>fh` | Help tags |

Inside picker: `<C-n>`/`<C-p>` next/prev, `<CR>` open, `<C-x>` horizontal split, `<C-v>` vertical split, `<C-t>` tab, `<Esc>` close.

### folke/trouble.nvim — Diagnostics / refs panel

| Key | Action |
|---|---|
| `<leader>xx` | Workspace diagnostics |
| `<leader>xb` | Buffer diagnostics |
| `<leader>xs` | Symbols outline |
| `<leader>xl` | LSP refs / defs (right split) |
| `<leader>xq` | Quickfix list |

Inside panel: `<CR>` jump, `q` close, `r` refresh.

---

## Editing

### kylechui/nvim-surround — Surround text

| Key | Action |
|---|---|
| `ys{motion}{char}` | Add surround (e.g. `ysiw"` wraps word in quotes) |
| `ds{char}` | Delete surround |
| `cs{old}{new}` | Change surround |
| `S{char}` (visual) | Surround selection |

Examples: `ysiw)` → `(word)`. `cs"'` → `"foo"` becomes `'foo'`. `ds(` → drop parens.

### nvim-treesitter — Syntax highlighting & text objects

Highlighting is automatic. Text objects (require treesitter-textobjects):

| Key | Selects |
|---|---|
| `af` / `if` | Function (outer / inner) |
| `ac` / `ic` | Class (outer / inner) |
| `aa` / `ia` | Parameter (outer / inner) |

Move between nodes:

| Key | Action |
|---|---|
| `]f` / `[f` | Next / prev function |
| `]c` / `[c` | Next / prev class |

---

## LSP & Completion

### neovim/nvim-lspconfig + mason.nvim — Language servers

Servers auto-install on first use: lua, python, typescript, rust, go, c/c++, json, yaml, html, css, bash. Manage with `:Mason`.

LSP keymaps (active when an LSP attaches):

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | References |
| `gi` | Go to implementation |
| `gy` | Type definition |
| `K` | Hover docs |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>ls` | Document symbols |
| `<leader>lS` | Workspace symbols |
| `<leader>uh` | Toggle inlay hints |

### saghen/blink.cmp — Completion

Pops up automatically while typing. Sources: LSP, snippets (LuaSnip), path, buffer.

| Key | Action |
|---|---|
| `<C-n>` / `<C-p>` | Next / prev item |
| `<CR>` | Confirm selection |
| `<Tab>` | Snippet jump / select |
| `<C-Space>` | Trigger menu |
| `<C-e>` | Cancel |

### L3MON4D3/LuaSnip + friendly-snippets
VSCode snippet pack auto-loaded. Trigger via blink.cmp; jump fields with `<Tab>`.

---

## Formatting

### stevearc/conform.nvim — Formatter

Format on save runs automatically (500ms timeout, falls back to LSP). Manual:

| Key | Action |
|---|---|
| `<leader>cf` | Format buffer / selection |

Formatters by filetype: stylua (lua), ruff (python), prettierd → prettier (js/ts/json/yaml/html/css/md), rustfmt, gofmt, shfmt. Install via `:Mason`.

`:ConformInfo` shows status.

---

## Git

### lewis6991/gitsigns.nvim — Git in gutter

Signs in signcolumn show added/changed/deleted lines.

| Key | Action |
|---|---|
| `]h` / `[h` | Next / prev hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |

---

## Diagnostics

Float opens automatically after 250ms idle on a problem (VSCode-style). Underlines show severity color. No virtual text.

| Key | Action |
|---|---|
| `<leader>dd` | Manual diagnostic float |
| `]d` / `[d` | Next / prev diagnostic |

See also Trouble (`<leader>xx`) for a full panel.
