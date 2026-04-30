# Vim Tips

Workflow tricks and non-obvious combos for this Neovim setup. For full reference see [keymaps](keymaps.md), [plugins](plugins.md), [vim essentials](vim-essentials.md), [quickfix](quickfix.md).

---

## Operators × text objects compose

Every `{op}{motion}` and `{op}{textobject}` works with every plugin-provided text object. Memorize the operators and you get the matrix for free:

- `daf` — delete a function (treesitter)
- `cif` — change inner function body
- `yaa` — yank a parameter (treesitter)
- `vih` — select inner git hunk (gitsigns)
- `dih` — delete the hunk under cursor without staging
- `>ic` — indent inner class
- `gcaf` — comment a whole function

Counts work too: `d3aw` deletes three words, `c2af` rewrites two functions.

## `.` is your best friend

`.` repeats the last change. To make it powerful:

- Set up edits so the change is what you want repeated. `cgn` after `*` lets you change the next match, then `.` keeps replacing matches one by one — like multi-cursor without leaving normal mode.
- Use `*` (search word under cursor) → `cgn` → type new text → `<Esc>` → `n.n.n.` for selective find/replace. Skip a match with `n`, accept with `.`.
- Prefer `c` over `d`+`i` so the dot replays the whole edit.

## Macros beat repetitive edits

`qa` … `q` records into register `a`. `@a` plays back, `@@` repeats last macro, `5@a` runs five times.

- Edit a macro: `:let @a='...'` or paste with `"ap`, edit, then yank back with `"ay`.
- Apply a macro to every quickfix entry: `:cdo norm @a | update`.
- Visual selection → `:normal @a` runs macro on each selected line.

## Flash beyond `s`

Flash isn't only for jumping in normal mode:

- `yr` + flash label = "yank from a remote location" — yanks at the labeled spot, returns cursor here. Same for `dr`, `cr`.
- `S` jumps to a treesitter node — fast way to land on a function/argument.
- `<C-s>` inside `/search` toggles flash labels on the search results — pick the label to jump.

## Treesitter motions chain with operators

`]f` and `[f` are motions, not just navigation:

- `d]f` — delete from cursor to start of next function.
- `y]c` — yank through next class.
- `v]f` — visual select to next function.

## Surround tricks

- `ysiw)` vs `ysiw(` — closing bracket = no padding, opening bracket = padded (`( word )`). Same for `]/[`, `}/{`.
- `cs"'` swaps `"` for `'`. Works for tags too: `cst<div>` changes surrounding tag to `<div>`.
- Visual select → `S<tag>` wraps in HTML tag.
- `yss)` wraps the entire line.

## Split / join code blocks

`<leader>j` toggles a block between single-line and multi-line form via treesj. Works on function args, table literals, JSX, etc. Cursor on the opening token (`(`, `{`, `[`).

## Tabout in insert mode

Inside brackets/quotes, `<Tab>` jumps past the closing delimiter without leaving insert mode. Stop hand-deleting closing parens.

## gn — operate on next match

`/pattern<CR>` then:

- `gn` selects next match (like `n` + visual).
- `dgn` deletes next match.
- `cgn` changes next match — pair with `.` for find/replace by hand.
- `gN` is the backward variant.

## Quickfix as a project workspace

Treat the quickfix list as a worklist:

1. `:vimgrep /TODO/ **/*.lua` or `<leader>fg` (live grep, send to qf with `<C-q>` in snacks picker).
2. Tab-mark the entries you care about in bqf (`<Tab>`), then `zn` to filter to them.
3. `:cdo s/old/new/g | update` to bulk-edit, or `:cdo norm @a | update` for macro-driven edits.
4. `:colder` / `:cnewer` to walk previous lists if a grep clobbered the one you wanted.

`<leader>q[` / `<leader>q]` are the keymapped versions of `:colder`/`:cnewer`.

## Snacks picker shortcuts

Inside any picker:

- `<C-q>` sends current results to quickfix — bridge picker → qf workflow.
- `<C-x>` / `<C-v>` / `<C-t>` open in split / vsplit / tab.
- Type to fuzzy-filter, then `<Tab>` to multi-select before opening.
- `<leader>fr` (recent files) is faster than re-typing paths.
- `<leader>f/` greps inside the current buffer only — like `/` but fuzzy.

## Live grep refinement

`<leader>fg`, then `<C-g>` (in many picker bindings) toggles regex. Add `--` followed by a glob to filter: `foo -- *.lua`. Or pipe through to qf with `<C-q>` and use `:cfdo` for replace.

## Gitsigns text object

`vih` selects the current hunk. Combine with operators: `dih` discards a hunk locally, `=ih` re-indents only the changed region, `gcih` comments out a hunk.

## Stage by selection

In visual mode, `<leader>gs` stages exactly the highlighted lines (gitsigns). No need to stage the whole hunk.

## Diffview for review, not just diffs

- `:DiffviewOpen main..feature` reviews a feature branch like a PR locally.
- `:DiffviewFileHistory %` walks every commit that touched the current file with diffs visible.
- Inside a merge conflict file: `[x` / `]x` to navigate, `<leader>co/ct/cb/ca` to pick ours/theirs/base/all per region.

## LSP rename across the project

`<leader>rn` renames the symbol everywhere LSP knows about it. The file explorer's `r` (rename) is also LSP-aware via `Snacks.rename` — moves a file *and* updates imports.

## Code action driven refactors

`<leader>ca` exposes server-side refactors: extract function, inline variable, organize imports, fill missing fields, etc. Most LSPs surface a lot more than the autofix. Check it before writing the refactor by hand.

## Trouble for fix-everything workflows

`<leader>xx` opens the workspace diagnostics list. `j`/`k` to navigate, `<CR>` to jump, `r` to refresh. Pair with format-on-save and code actions to chew through diagnostics fast. `<leader>xs` gives a symbol outline of the current buffer — quick way to land on a function in a long file.

## Inlay hints toggle

`<leader>uh` toggles LSP inlay hints. Useful to flip on while reading unfamiliar typed code, off while writing.

## Format on save without surprises

Format-on-save runs conform with a 500ms timeout. To check what would run: `:ConformInfo`. To skip just once: `:noa w` (write without autocmds). To disable temporarily: `:lua require('conform').format = function() end` or just toggle in conform docs.

## Window prefix as leader

`<leader>w` is a full proxy for `<C-w>`. So `<leader>ws` = horizontal split, `<leader>wv` = vertical, `<leader>wh/j/k/l` = navigate, `<leader>w=` = equalize, `<leader>wT` = move to new tab. If `<C-w>` chords feel awkward, the leader version is identical.

## Buffer hygiene

- `<leader>br` / `<leader>bl` close all buffers right/left of the current one — fast cleanup after exploration.
- `<leader>bp` pins a buffer (bufferline keeps it stuck on the left); `<leader>bP` then closes everything not pinned.
- `<leader>bo` closes everything except the current buffer.

## Alt-buffer hop

`<leader>` + backtick (or `<leader>bb`) jumps to the previously focused buffer. Pair two files (test + impl) and bounce.

## Visual paste preserves yank

Default Vim overwrites the yank register when you paste over a selection. This config remaps visual `p` to keep the original yank, so `yy` then `Vp` repeatedly works correctly.

## System clipboard

- `<leader>y` (n, v) yanks to `+`.
- `:%y+` yanks the whole file to the system clipboard.
- `<C-S-V>` in normal mode pastes from system clipboard.
- The `+` register is also set as default in this config — most yanks are already shared.

## Centered scrolling

`<C-d>` / `<C-u>` half-page jumps recenter the cursor. So do `n` / `N` after a search, and `]d` / `]q` / `]h` jumps. Reading stays anchored in the middle of the screen.

## `gf`, `gx`, and friends

- `gf` — open file path under cursor.
- `gx` — open URL/path with system handler.
- `K` — LSP hover (or `:help` topic in vim files).
- `gd` / `gr` / `gi` / `gy` — definition / refs / implementation / type def (LSP).
- `*` / `#` — search word under cursor; great paired with `cgn`.

## `:%!cmd` filter

`:%!sort -u` runs the buffer through a shell command and replaces it with the output. `:'<,'>!jq .` formats a JSON selection. Combine with visual mode to filter only part of the file.

## Counted line jumps

`:42<CR>` or `42G` jumps to line 42. `:42` shows it without moving. `<C-o>` returns to the prior position.

## Marks across files

`mA` (uppercase) sets a global mark. `` `A `` jumps from anywhere to that exact spot, even in a different file. Useful as breadcrumbs while exploring an unfamiliar codebase.

## Insert-mode escape hatches

- `<C-w>` deletes the previous word.
- `<C-u>` deletes to start of line.
- `<C-r>{reg}` inserts from a register without leaving insert mode (`<C-r>"` for last yank, `<C-r>+` for clipboard).
- `<C-o>{cmd}` runs one normal command then drops back into insert.

## `:help` is the manual

Everything is documented. `:help text-objects`, `:help :cdo`, `:help flash.txt`, `:help gitsigns-usage`. Use `<leader>fh` (help tags picker) to fuzzy-search.

## Discovery: `<leader>fk`

Lists every keymap with descriptions. When unsure what's bound, search here first.
