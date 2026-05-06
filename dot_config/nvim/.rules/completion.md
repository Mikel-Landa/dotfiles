# Completion

- `blink.cmp` (replaces nvim-cmp). Single plugin; sources `lsp / snippets / path / buffer` built-in
- Snippets: `LuaSnip` + `friendly-snippets` (vscode pack auto-loaded)
- Add new sources via `opts.sources.default` in `lua/plugins/completion.lua` — do not pull `cmp-*` source plugins
