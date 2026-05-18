# Keymaps

Leader: `<Space>` (set in `lua/config/keymaps.lua`).

Always use `vim.keymap.set`, always provide `desc`:

```lua
vim.keymap.set("n", "<leader>xx", function() ... end, { desc = "Short description" })
```

**Leader group conventions** (follow existing layout):

| Prefix | Domain |
|---|---|
| `<leader>f` | Find (fff.nvim for files/grep, snacks.picker for the rest) |
| `<leader>b` | Buffers |
| `<leader>g` | Git / hunks (gitsigns + snacks.picker) |
| `<leader>gt` | Git toggles (inline blame, deleted, word diff) |
| `<leader>gv` | CodeDiff (day-to-day diff viewer) |
| `<leader>gG` | CodeDiff vs origin default branch (PR overlay) |
| `<leader>l` | LSP (symbols, etc.) |
| `<leader>d` | Diagnostics (`<leader>dd` = float) |
| `<leader>x` | Trouble panel (diagnostics/symbols/refs) |
| `<leader>u` | UI toggles (`<leader>uh` = inlay hints, `<leader>un` = dismiss notif) |
| `<leader>c` | Code (action, format) |
| `<leader>e` | File explorer |
| `<leader>sn` | Noice (messages/cmdline) |
| `<leader>w` | Windows (proxy of `<C-w>`) |
| `<leader><tab>` | Tabs |

Group labels live in `which-key.nvim` spec inside `lua/plugins/which-key.lua` — keep in sync when adding a new prefix.

After touching keymaps run `nvim --headless -l scripts/check-keymaps.lua` from the config root — it diffs `vim.keymap.set` / `keys = {…}` declarations against `docs/keymaps.md` and exits 1 on drift.

Rules:
- Don't shadow core Vim motions (`w`, `b`, `e`, `gg`, `G`, `f`, `t`, etc.)
- Plugin keymaps that only apply in a buffer → set inside `on_attach` with `buffer = bufnr`
- Use `]`/`[` prefix for next/prev navigation (consistent with gitsigns, diagnostics)
- `<C-h/j/k/l>` reserved for tmux-navigator pane navigation
