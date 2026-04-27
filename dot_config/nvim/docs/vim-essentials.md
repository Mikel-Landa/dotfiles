# Vim Essentials

Built-in Vim/Neovim commands and motions worth knowing. Not config-specific — these work in any Vim. Pair with [user keymaps](keymaps.md).

---

## Modes

| Key | Mode |
|---|---|
| `i` | Insert (before cursor) |
| `a` | Insert (after cursor) |
| `I` / `A` | Insert at line start / end |
| `o` / `O` | New line below / above + insert |
| `v` | Visual (character) |
| `V` | Visual (line) |
| `<C-v>` | Visual (block) |
| `R` | Replace |
| `<Esc>` / `<C-[>` | Back to normal |

## Motions

| Key | Move |
|---|---|
| `h j k l` | Left / down / up / right |
| `w` / `W` | Next word / WORD start |
| `e` / `E` | Next word / WORD end |
| `b` / `B` | Prev word / WORD start |
| `0` | Line start (column 0) |
| `^` | First non-blank |
| `$` | Line end |
| `gg` | Top of file |
| `G` | Bottom of file |
| `{count}G` | Line `{count}` (e.g. `42G`) |
| `H` / `M` / `L` | Top / middle / bottom of viewport |
| `f{c}` / `F{c}` | Jump to next / prev `{c}` on line |
| `t{c}` / `T{c}` | Until next / prev `{c}` |
| `;` / `,` | Repeat last `f`/`t` forward / backward |
| `%` | Match bracket / paren |
| `*` / `#` | Search word under cursor forward / back |
| `<C-o>` / `<C-i>` | Jumplist back / forward |
| `''` | Last cursor position |
| `gd` | (overridden by LSP here) |

## Editing operators

Combine `{operator}{motion}` or `{operator}{text-object}`:

| Op | Action |
|---|---|
| `d` | Delete |
| `c` | Change (delete + insert) |
| `y` | Yank (copy) |
| `>` / `<` | Indent / dedent |
| `=` | Auto-indent |
| `gu` / `gU` | Lowercase / uppercase |
| `gc` | Toggle comment (built-in 0.10+) |

Examples: `daw` delete a word, `ci"` change inside quotes, `yip` yank inner paragraph, `>ap` indent a paragraph, `gcap` comment a paragraph.

## Text objects

`{a|i}{object}` — `a` = "around" (includes delimiter), `i` = "inner".

| Object | Means |
|---|---|
| `w` / `W` | word / WORD |
| `s` | sentence |
| `p` | paragraph |
| `"` `'` ` ` ` | matching quotes |
| `(` `)` `b` | parens |
| `[` `]` | brackets |
| `{` `}` `B` | braces |
| `<` `>` | angle brackets |
| `t` | XML/HTML tag |

## Repeat / undo

| Key | Action |
|---|---|
| `.` | Repeat last change |
| `u` | Undo |
| `<C-r>` | Redo |
| `U` | Undo all changes on line |

## Registers

| Key | Action |
|---|---|
| `"{r}{cmd}` | Use register `{r}` (e.g. `"ay` yank to `a`) |
| `"+` | System clipboard (synced by default in this config) |
| `"0` | Last yank |
| `""` | Last delete/yank |
| `"_` | Black hole (discard) |
| `:reg` | List all registers |

## Marks

| Key | Action |
|---|---|
| `m{a-z}` | Set buffer-local mark |
| `m{A-Z}` | Set global mark (across files) |
| `` `{m} `` | Jump to mark (exact) |
| `'{m}` | Jump to mark line |
| `:marks` | List marks |

## Search & replace

| Key | Action |
|---|---|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` / `N` | Next / prev match |
| `:%s/old/new/g` | Replace in file |
| `:%s/old/new/gc` | With confirmation |
| `:'<,'>s/old/new/g` | Replace in selection |

## Windows / splits

| Key | Action |
|---|---|
| `:split` / `<C-w>s` | Horizontal split |
| `:vsplit` / `<C-w>v` | Vertical split |
| `<C-w>w` | Cycle windows |
| `<C-w>q` | Close window |
| `<C-w>o` | Close all but current |
| `<C-w>=` | Equalize sizes |

(Pane move is `<C-h/j/k/l>` here, see [keymaps](keymaps.md).)

## Buffers / tabs

| Key | Action |
|---|---|
| `:e {file}` | Edit file |
| `:w` | Write |
| `:q` / `:q!` | Quit / force quit |
| `:wq` / `:x` | Write & quit |
| `:bd` | Delete buffer |
| `:ls` | List buffers |
| `:tabnew` | New tab |
| `gt` / `gT` | Next / prev tab |

## Macros

| Key | Action |
|---|---|
| `q{r}` | Start recording into register `{r}` |
| `q` | Stop recording |
| `@{r}` | Replay macro |
| `@@` | Replay last macro |

## Folds

| Key | Action |
|---|---|
| `zo` / `zc` | Open / close fold |
| `za` | Toggle fold |
| `zR` / `zM` | Open all / close all |

## Useful Ex commands

| Cmd | Does |
|---|---|
| `:checkhealth` | Diagnostic report |
| `:Lazy` | Plugin manager UI |
| `:Mason` | Install LSP / formatters / linters |
| `:LspInfo` | LSP attach status |
| `:ConformInfo` | Formatter status |
| `:messages` | Recent message log |
| `:noh` | Clear search highlight |
| `:%y+` | Yank whole file to system clipboard |
| `:!{cmd}` | Run shell command |
