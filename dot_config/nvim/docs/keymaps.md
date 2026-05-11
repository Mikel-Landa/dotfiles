# Keymaps

User-defined keybinds in this config. Leader = `<Space>`. For built-in motions and commands see [Vim Essentials](vim-essentials.md).

## Leader groups

| Prefix | Domain |
|---|---|
| `<leader>f` | Find (snacks.picker) |
| `<leader>b` | Buffers |
| `<leader>g` | Git / hunks |
| `<leader>l` | LSP (symbols) |
| `<leader>d` | Debug + diagnostics |
| `<leader>dP` | Python debug (subgroup) |
| `<leader>x` | Trouble panel |
| `<leader>q` | Quickfix |
| `<leader>u` | UI toggles |
| `<leader>c` | Code (action, format) |
| `<leader>e` | File explorer |
| `<leader>o` | Workflow (remote PR/issue browsers) |
| `<leader>p` | Path |
| `<leader>a` | Avante (AI assistant) |
| `<leader>sn` | Noice (messages/cmdline) |
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
| `<leader>fr` | Recent files (cwd) |
| `<leader>fR` | Recent files (all) |
| `<leader>fk` | Keymaps |
| `<leader>f/` | Lines (current buffer) |
| `<leader>fd` | Diagnostics |
| `<leader>fn` | Notification history |
| `<leader>fc` | Config files (`$XDG_CONFIG_HOME/nvim`) |
| `<leader>ft` | TODO/FIXME comments |

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
| `<leader>e` | Toggle file tree (snacks.explorer) |

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
| `<leader>gO` | Open file in browser (n, v) |

### CodeDiff

| Key | Action |
|---|---|
| `<leader>gg` | Toggle codediff |
| `<leader>gG` | Toggle codediff vs origin default branch (PR overlay) |
| `<leader>gvo` | CodeDiff open |
| `<leader>gvc` | CodeDiff close |
| `<leader>gvh` | File history (repo) |
| `<leader>gvf` | File history (current file) |

### Toggles

| Key | Action |
|---|---|
| `<leader>gtb` | Toggle inline blame |
| `<leader>gtd` | Toggle deleted lines |
| `<leader>gtw` | Toggle word diff |

### PR comments overlay (CodeDiff + Bitbucket)

Active inside a CodeDiff session for a Bitbucket PR. Signs `` (published) / `` (pending) appear in the gutter at commented lines.

| Key | Mode | Action |
|---|---|---|
| `<leader>oc` | n | Load PR comments for current branch into quickfix |
| `<leader>oC` | n | Clear PR comments: drop qf list, signs, and `K` peek bindings |
| `K` | n | Code buffer: peek thread popup at cursor (falls through to LSP hover if no thread); qf list: peek selected entry's thread |
| `]q` / `[q` | n | Native `:cnext` / `:cprev` — advances qf entry, code window auto-previews |

Inside the qf list (title `PR Comments`):

- cursor on entry → thread renders inline as `virt_lines` below the entry; the adjacent code window silently scrolls to the entry's `file:line` (cursor stays in qf)
- `<CR>` → jump focus into the previewed code window
- `r` → reply to the entry's thread root
- `d` → delete the whole thread (confirm prompt)
- `e` → edit the thread root body (own root only)
- `K` → floating popup with full per-comment `r` / `e` / `d` (use this for actions on individual replies)

Review actions (Approve / Request changes) are exposed as atlas-pulls custom actions — open `:AtlasPulls bitbucket`, select a PR, press `A` to invoke.

### Text object

| Key | Mode | Selects |
|---|---|---|
| `ih` | o, x | Inner hunk (e.g. `dih`, `vih`) |

## LSP (active when server attached)

References / implementation / type-def / rename / code-action use Neovim 0.11 built-in defaults under the `gr` prefix.

| Key | Action |
|---|---|
| `gd` | Definition (snacks.picker) |
| `grr` | References (built-in) |
| `gri` | Implementation (built-in) |
| `grt` | Type definition (built-in) |
| `grn` | Rename symbol (built-in) |
| `gra` | Code action (built-in, n/x) |
| `gO` | Document symbols (built-in) |
| `K` | Hover docs |
| `<C-s>` | Signature help (insert mode, built-in) |
| `<leader>ca` | Code action |
| `<leader>lr` | Rename symbol |
| `<leader>ls` | Document symbols |
| `<leader>lS` | Workspace symbols |
| `<leader>lv` | Definition in vertical split |
| `<leader>uh` | Toggle inlay hints |

### TypeScript / JavaScript (vtsls)

| Key | Action |
|---|---|
| `gD` | Goto source definition |
| `gR` | File references |
| `<leader>co` | Organize imports + format |
| `<leader>cM` | Add missing imports |
| `<leader>cD` | Fix all diagnostics |
| `<leader>cu` | Remove unused |

### Rust (rustaceanvim)

| Key | Action |
|---|---|
| `<leader>cR` | Rust code action |
| `<leader>dr` | Rust debuggables (DAP) |

### C / C++ (clangd)

| Key | Action |
|---|---|
| `<leader>ch` | Switch source / header |

### Python

| Key | Action |
|---|---|
| `<leader>cv` | Select virtualenv (venv-selector) |
| `<leader>dPt` | Debug test method |
| `<leader>dPc` | Debug test class |

### Markdown

| Key | Action |
|---|---|
| `<leader>cp` | Toggle browser preview (markdown-preview.nvim) |

## Diagnostics

| Key | Action |
|---|---|
| `<leader>dd` | Float at cursor |
| `]d` / `[d` | Next / prev diagnostic |

## Debug (DAP)

Two-letter keys under `<leader>d` (single-letter `<leader>dd` reserved for diagnostics).

| Key | Action |
|---|---|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Breakpoint w/ condition |
| `<leader>dc` | Run / Continue |
| `<leader>dC` | Run to cursor |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>dO` | Step over |
| `<leader>dj` / `<leader>dk` | Down / up the call stack |
| `<leader>dg` | Go to line (no execute) |
| `<leader>dl` | Run last config |
| `<leader>dp` | Pause |
| `<leader>dr` | Toggle REPL |
| `<leader>ds` | Session |
| `<leader>dt` | Terminate |
| `<leader>dw` | Widgets hover |
| `<leader>du` | Toggle DAP UI |
| `<leader>de` (n, v) | Eval expression / selection |

## Quickfix / loclist

Navigation (unimpaired-style):

| Key | Action |
|---|---|
| `]q` / `[q` | Next / prev quickfix entry |
| `]Q` / `[Q` | Last / first quickfix entry |
| `]<C-q>` / `[<C-q>` | Next / prev quickfix file |
| `]l` / `[l` | Next / prev loclist entry |
| `]L` / `[L` | Last / first loclist entry |
| `]<C-l>` / `[<C-l>` | Next / prev loclist file |

Manage:

| Key | Action |
|---|---|
| `<leader>qo` / `<leader>qc` | Open / close quickfix |
| `<leader>qx` | Clear quickfix |
| `<leader>q[` / `<leader>q]` | Older / newer quickfix list |
| `<leader>lo` / `<leader>lc` | Open / close loclist |

Bulk edit across qf entries: `:cdo s/foo/bar/g | update`. See [Quickfix](quickfix.md) for the full reference.

## Trouble panel

| Key | Action |
|---|---|
| `<leader>xx` | Workspace diagnostics |
| `<leader>xb` | Buffer diagnostics |
| `<leader>xs` | Symbols |
| `<leader>xl` | LSP refs/defs |
| `<leader>xq` | Quickfix |
| `<leader>xt` | TODO/FIXME comments |

## Format

| Key | Action |
|---|---|
| `<leader>cf` | Format buffer (or selection in visual) |
| `grf` | Format file |

Format on save runs automatically.

## Noice (messages / cmdline)

| Key | Mode | Action |
|---|---|---|
| `<leader>snl` | n | Last message |
| `<leader>snh` | n | Message history |
| `<leader>sna` | n | All messages |
| `<leader>snd` | n | Dismiss all |
| `<S-Enter>` | c | Redirect cmdline output |
| `<C-f>` / `<C-b>` | n, i, s | Scroll forward/back inside LSP hover/signature |

## UI toggles

| Key | Action |
|---|---|
| `<leader>ud` | Toggle diagnostics on/off |
| `<leader>un` | Dismiss notifications (snacks.notifier) |
| `<leader>uh` | Toggle inlay hints |
| `<leader>ui` | Toggle indent guides (current buffer) |
| `<leader>uw` | Toggle word wrap (current buffer) |
| `<leader>uu` | Open undo tree (built-in `:Undotree`) |

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
| `J` | normal | Join lines (cursor position preserved) |
| `<leader>j` | normal | Toggle split / join block (treesj) |
| `<leader>D` | n, v | Delete without yank (black-hole register) |
| `<leader>pa` | n | Copy absolute file path to system clipboard |
| `p` | visual | Paste without yanking the replaced text |
| `<C-d>` | normal | Half-page down (cursor centered) |
| `<C-u>` | normal | Half-page up (cursor centered) |
| `n` / `N` | normal | Next / prev search match (centered, unfolded) |
| `<C-s>` | n, i, v | Save file |
| `<leader>y` | n, v | Yank to system clipboard |
| `<C-S-V>` | n | Paste from system clipboard |

## Treesitter text objects

| Key | Mode | Selects / moves |
|---|---|---|
| `af` / `if` | x, o | Function outer / inner |
| `ac` / `ic` | x, o | Class outer / inner |
| `aa` / `ia` | x, o | Parameter outer / inner |
| `]f` / `[f` | n | Next / prev function |
| `]c` / `[c` | n | Next / prev class |

## Flash (flash.nvim)

| Key | Mode | Action |
|---|---|---|
| `s` | n, x, o | Flash jump |
| `S` | n, x, o | Flash Treesitter |
| `r` | o | Remote Flash |
| `R` | o, x | Treesitter Search |
| `<C-s>` | c | Toggle Flash in `/` search |

## Surround (mini.surround)

| Key | Action |
|---|---|
| `ys{motion}{char}` | Add surround |
| `ds{char}` | Delete surround |
| `cs{old}{new}` | Change surround |
| `S{char}` (visual) | Surround selection |
| `gsf` / `gsF` | Find surround right / left |
| `gsh` | Highlight surround |

## Move lines (mini.move)

| Key | Mode | Action |
|---|---|---|
| `<A-j>` / `<A-k>` | n, v | Move line / selection down / up |
| `<A-h>` / `<A-l>` | n, v | Move line / selection left / right |

## Workflow / remote PR & issue browsers (`<leader>o`)

`:Workflow` opens a picker; direct keymaps below skip it. See [plugins.md](plugins.md#workflow-remote-pr--issue-browsers) for atlas + octo command reference.

| Key | Action |
|---|---|
| `<leader>oo` | Workflow picker (PRs + issues, all providers) |
| `<leader>op` | PRs — auto-detects GitHub/Bitbucket from `git remote`; falls back to picker |
| `<leader>oi` | Issues — GitHub repo → Octo, else → Jira (Atlas) |

## Avante (AI assistant)

Avante drives Claude Code via ACP (no API key — uses `claude` CLI auth). `<leader>ac` opens Cursor's CLI agent in a floating terminal as an alternative.

| Key | Action |
|---|---|
| `<leader>aa` | Open Avante sidebar (ask) — claude-code |
| `<leader>at` | Toggle sidebar |
| `<leader>an` | New ask prompt |
| `<leader>ae` | Edit selected blocks (visual mode) |
| `<leader>ar` | Refresh sidebar |
| `<leader>af` | Switch focus between windows |
| `<leader>ac` | `cursor-agent` floating terminal |

In the Avante sidebar:

| Key | Action |
|---|---|
| `<CR>` | Submit prompt (normal mode) |
| `<C-s>` | Submit prompt (insert mode) |
| `<M-l>` | Accept inline suggestion |
| `co` / `ct` / `cb` | Choose ours / theirs / both on conflict |

## Completion (blink.cmp, in insert mode)

| Key | Action |
|---|---|
| `<C-n>` / `<C-p>` | Next / prev candidate |
| `<C-j>` / `<C-k>` | Next / prev candidate; snippet jump forward / backward |
| `<CR>` | Confirm |
| `<C-CR>` | Hide menu + open new line below (`<Esc>o`) |
| `<C-S-CR>` | Hide menu + open new line above (`<Esc>O`) |
| `<Tab>` / `<S-Tab>` | Tab out of brackets/quotes forward / backward (tabout.nvim) |
| `<C-Space>` | Trigger menu |
| `<C-e>` | Cancel |

## TODO comments (todo-comments.nvim)

| Key | Action |
|---|---|
| `]t` / `[t` | Next / prev TODO marker |
| `<leader>ft` | TODO list (snacks.picker) |
| `<leader>xt` | TODO list (Trouble) |

## Terminal

| Key | Action |
|---|---|
| `<leader>t` | Toggle floating terminal |
| `<Esc><Esc>` | Exit terminal mode (return to normal) |

## Filetype helper buffers

In `help`, `man`, `qf`, `lspinfo`, `checkhealth` buffers: press `q` to close.
