# Docs maintenance (mandatory)

User-facing docs live in `docs/`:

- `docs/plugins.md` — every installed plugin: what it does, how to use it
- `docs/keymaps.md` — leader-prefixed user keybinds
- `docs/vim-essentials.md` — built-in motions/commands worth knowing
- `README.md` (root) — links to the above

**Any change that affects user-visible behavior must update the relevant doc in the same change.** Triggers:

- Add / remove a plugin → update `docs/plugins.md`
- Change a keymap (`vim.keymap.set`, `keys = {}`, `on_attach` map) → update `docs/keymaps.md` (and `docs/plugins.md` if plugin-scoped)
- Add a new leader group → update the group table in `docs/keymaps.md` AND the which-key spec in `lua/plugins/ui.lua`
- Rename / move a file referenced from docs → update links

Docs target end users — describe usage, not internals. No `lua/...` paths or implementation details in user docs.
