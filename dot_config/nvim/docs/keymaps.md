# Keymaps

User-defined keybinds in this config. Leader = `<Space>`. For built-in motions and commands see [Vim Essentials](vim-essentials.md).

## Leader groups

| Prefix | Domain |
|---|---|
| `<leader>f` | Find (snacks.picker) |
| `<leader>b` | Buffers |
| `<leader>g` | Git / hunks |
| `<leader>l` | LSP (symbols) |
| `<leader>d` | Diagnostics |
| `<leader>x` | Trouble panel |
| `<leader>u` | UI toggles |
| `<leader>c` | Code (action, format) |
| `<leader>r` | Rename / refactor |
| `<leader>e` | File explorer |
| `<leader>w` | Windows (proxy of `<C-w>`) |
| `<leader><tab>` | Tabs |

Press leader and pause — which-key shows the menu.

---

## Find (snacks.picker)

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fr` | Recent files |
| `<leader>fk` | Keymaps |
| `<leader>f/` | Lines (current buffer) |
| `<leader>fd` | Diagnostics |
| `<leader>fn` | Notification history |

## Buffers

| Key | Action |
|---|---|
| `[b` / `]b` | Prev / next buffer (bufferline cycle) |
| `<S-h>` / `<S-l>` | Prev / next buffer (bufferline cycle) |
| `[B` / `]B` | Move buffer left / right in bufferline |
| `<leader>bb` / `` <leader>` `` | Switch to other buffer (alt-buffer) |
| `<leader>bd` | Delete buffer (keep window) |
| `<leader>bD` | Delete buffer + window |
| `<leader>bo` | Delete other buffers |
| `<leader>bp` | Toggle pin |
| `<leader>bP` | Delete non-pinned buffers |
| `<leader>br` | Delete buffers to the right |
| `<leader>bl` | Delete buffers to the left |

## File explorer

| Key | Action |
|---|---|
| `<leader>e` | Toggle Neo-tree |

## Git hunks (gitsigns)

### Navigation

| Key | Action |
|---|---|
| `]h` / `[h` | Next / prev hunk (falls back to `]c` / `[c` in diff mode) |
| `]H` / `[H` | Last / first hunk |

### Stage / reset

| Key | Mode | Action |
|---|---|---|
| `<leader>gs` | n | Stage hunk |
| `<leader>gs` | v | Stage selection |
| `<leader>gr` | n | Reset hunk |
| `<leader>gr` | v | Reset selection |
| `<leader>gS` | n | Stage buffer |
| `<leader>gR` | n | Reset buffer |
| `<leader>gu` | n | Undo stage hunk |

### Inspect

| Key | Action |
|---|---|
| `<leader>gp` | Preview hunk (floating diff) |
| `<leader>gb` | Blame current line (full) |
| `<leader>gd` | Diff vs index |
| `<leader>gD` | Diff vs `HEAD~` |

### Browse (snacks.picker)

| Key | Action |
|---|---|
| `<leader>gf` | Git status — pick changed file, preview diff |
| `<leader>gl` | Git log (repo) |
| `<leader>gL` | Git log (current file) |
| `<leader>gB` | Git branches |

### Lazygit

| Key | Action |
|---|---|
| `<leader>gg` | Lazygit (floating) |
| `<leader>gG` | Lazygit log (cwd) |

### Toggles

| Key | Action |
|---|---|
| `<leader>gtb` | Toggle inline blame |
| `<leader>gtd` | Toggle deleted lines |
| `<leader>gtw` | Toggle word diff |

### Text object

| Key | Mode | Selects |
|---|---|---|
| `ih` | o, x | Inner hunk (e.g. `dih`, `vih`) |

## LSP (active when server attached)

| Key | Action |
|---|---|
| `gd` | Definition |
| `gr` | References |
| `gi` | Implementation |
| `gy` | Type definition |
| `K` | Hover docs |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>ls` | Document symbols |
| `<leader>lS` | Workspace symbols |
| `<leader>uh` | Toggle inlay hints |

## Diagnostics

| Key | Action |
|---|---|
| `<leader>dd` | Float at cursor |
| `]d` / `[d` | Next / prev diagnostic |

## Trouble panel

| Key | Action |
|---|---|
| `<leader>xx` | Workspace diagnostics |
| `<leader>xb` | Buffer diagnostics |
| `<leader>xs` | Symbols |
| `<leader>xl` | LSP refs/defs |
| `<leader>xq` | Quickfix |

## Format

| Key | Action |
|---|---|
| `<leader>cf` | Format buffer (or selection in visual) |

Format on save runs automatically.

## Window / pane navigation

| Key | Action |
|---|---|
| `<C-h/j/k/l>` | Move pane (works across tmux) |
| `<C-Up>` | Resize up |
| `<C-Down>` | Resize down |
| `<C-Left>` | Resize left |
| `<C-Right>` | Resize right |
| `<leader>w` | Window prefix (replaces `<C-w>`; all default subkeys work) |
| `<leader>-` / `<leader>w-` | Split below |
| `<leader>\|` / `<leader>w\|` | Split right |
| `<leader>ws` / `<leader>wv` | Split horizontal / vertical (vim default) |
| `<leader>wd` / `<leader>wq` / `<leader>wc` | Close window |
| `<leader>wo` | Only window (close others) |
| `<leader>w=` | Equalize sizes |
| `<leader>wh/j/k/l` | Move to pane (alt to `<C-h/j/k/l>`) |
| `<leader>wT` | Move window to new tab |

## Tabs

| Key | Action |
|---|---|
| `<leader><tab><tab>` | New tab |
| `<leader><tab>]` / `<leader><tab>[` | Next / prev tab |
| `<leader><tab>f` / `<leader><tab>l` | First / last tab |
| `<leader><tab>d` | Close tab |
| `<leader><tab>o` | Close other tabs |
| `gt` / `gT` | Next / prev tab (vim default) |
| `<N>gt` | Go to tab N |

## Misc edits

| Key | Mode | Action |
|---|---|---|
| `J` | visual | Move selection down |
| `K` | visual | Move selection up |
| `p` | visual | Paste without yanking the replaced text |
| `<C-d>` | normal | Half-page down (cursor centered) |
| `<C-u>` | normal | Half-page up (cursor centered) |
| `n` / `N` | normal | Next / prev search match (centered, unfolded) |

## Treesitter text objects

| Key | Mode | Selects / moves |
|---|---|---|
| `af` / `if` | x, o | Function outer / inner |
| `ac` / `ic` | x, o | Class outer / inner |
| `aa` / `ia` | x, o | Parameter outer / inner |
| `]f` / `[f` | n | Next / prev function |
| `]c` / `[c` | n | Next / prev class |

## Surround (nvim-surround)

| Key | Action |
|---|---|
| `ys{motion}{char}` | Add surround |
| `ds{char}` | Delete surround |
| `cs{old}{new}` | Change surround |
| `S{char}` (visual) | Surround selection |

## Completion (blink.cmp, in insert mode)

| Key | Action |
|---|---|
| `<C-n>` / `<C-p>` | Next / prev candidate |
| `<CR>` | Confirm |
| `<Tab>` | Snippet jump / select |
| `<C-Space>` | Trigger menu |
| `<C-e>` | Cancel |

## Filetype helper buffers

In `help`, `man`, `qf`, `lspinfo`, `checkhealth` buffers: press `q` to close.
