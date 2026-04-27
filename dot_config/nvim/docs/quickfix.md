# Quickfix & Location List

Native Vim quickfix is a project-wide list of `file:line:col + message` entries.
Location list is the same thing, scoped to a single window. Both are populated
by commands and consumed via navigation keymaps.

## Populate

| Command                              | Source                                  |
| ------------------------------------ | --------------------------------------- |
| `:vimgrep /pat/ **/*.lua`            | Built-in grep, regex, walks files       |
| `:grep pattern`                      | External grep (`grepprg`)               |
| `:make`                              | Build output via `makeprg` + `errorformat` |
| `:cexpr expand('%')`                 | Manual — current file as one entry      |
| `vim.diagnostic.setqflist()`         | All diagnostics → qf                    |
| `vim.diagnostic.setloclist()`        | Window diagnostics → loclist            |
| LSP refs / impls                     | Many configs send to qf or loclist      |

`:l<cmd>` variants (`:lvimgrep`, `:lgrep`, `:lmake`) populate loclist instead.

## Navigation (configured)

| Keys              | Action                                    |
| ----------------- | ----------------------------------------- |
| `]q` / `[q`       | Next / prev quickfix entry                |
| `]Q` / `[Q`       | Last / first quickfix entry               |
| `]<C-q>` / `[<C-q>` | Next / prev quickfix **file**           |
| `]l` / `[l`       | Next / prev loclist entry                 |
| `]L` / `[L`       | Last / first loclist entry                |
| `]<C-l>` / `[<C-l>` | Next / prev loclist **file**            |
| `<leader>qo`      | Open quickfix window                      |
| `<leader>qc`      | Close quickfix window                     |
| `<leader>qx`      | Clear quickfix list                       |
| `<leader>q[` / `<leader>q]` | Older / newer qf list (history) |
| `<leader>lo` / `<leader>lc` | Open / close loclist            |
| `<leader>xq`      | Trouble qflist viewer (alt UI)            |

All jumps recenter cursor (`zz`).

## Bulk edit across qf

```vim
:cdo s/foo/bar/g | update      " run cmd on every qf ENTRY
:cfdo %s/foo/bar/g | update    " run cmd ONCE per qf FILE
:ldo  ...                      " loclist version of :cdo
:lfdo ...                      " loclist version of :cfdo
```

`update` writes the buffer only if changed. Combine with `:vimgrep` for
project-wide search-and-replace:

```vim
:vimgrep /OldName/ **/*.lua
:cfdo %s/OldName/NewName/g | update
```

## History

Vim keeps the last 10 quickfix lists. `:colder` / `:cnewer` switch between
them — useful when a new `:grep` clobbered the list you wanted.

## nvim-bqf cheatsheet

Active in any quickfix or loclist window.

| Key       | Action                                  |
| --------- | --------------------------------------- |
| `p`       | Toggle preview pane                     |
| `P`       | Toggle preview auto-mode                |
| `<Tab>`   | Multi-select entry (visual-mode-like)   |
| `<S-Tab>` | Multi-select prev                       |
| `K` / `J` | Jump to prev / next file in list        |
| `v`       | Open entry in vsplit                    |
| `s`       | Open entry in split                     |
| `t`       | Open entry in tab                       |
| `zn`      | Filter qf to selected entries           |
| `zN`      | Filter qf to NON-selected entries       |
| `zf`      | Fzf-filter inside qf (if fzf installed) |

`zn` + `<Tab>` workflow: mark relevant entries with `<Tab>`, hit `zn` to drop
the rest. Combine with `:cdo` for surgical bulk edits.
