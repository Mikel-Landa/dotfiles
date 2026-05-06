# Neovim Config — Agent Guidelines

Plugin manager: **lazy.nvim**. Entry point: `init.lua`.

## Always edit via chezmoi

This config is managed by chezmoi. **Always edit the source at `~/.local/share/chezmoi/dot_config/nvim/`**, never the rendered copy at `~/.config/nvim/` directly. Target-side edits are clobbered on the next `chezmoi apply`.

Applies even when invoked from `~/.config/nvim/` or anywhere outside the chezmoi folder — switch to the source path before making changes. After editing, run `chezmoi apply` (or `chezmoi diff` first to preview).

## Topic rules

Read the relevant file in `.rules/` before making changes in that area. Each is self-contained.

| Topic | File |
|---|---|
| Docs maintenance (mandatory on user-visible changes) | `.rules/docs.md` |
| Folder structure | `.rules/structure.md` |
| Adding plugins, lazy-loading triggers, `opts` vs `config` | `.rules/plugins.md` |
| Keymaps + leader group conventions | `.rules/keymaps.md` |
| Vim options | `.rules/options.md` |
| LSP config (0.11+ API) | `.rules/lsp.md` |
| Per-language bundles + LazyVim porting | `.rules/lang.md` |
| Completion (blink.cmp) | `.rules/completion.md` |
| Diagnostics | `.rules/diagnostics.md` |
| Treesitter | `.rules/treesitter.md` |
| General rules, perf budget, anti-patterns | `.rules/general.md` |

## Maintaining this file

When adding a new `.rules/*.md`, add it to the table above with a short description.
