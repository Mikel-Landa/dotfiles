# Completion

- `blink.cmp` (replaces nvim-cmp). Single plugin; sources `lsp / snippets / path / buffer` built-in
- Snippets: native `vim.snippet` through Blink + `friendly-snippets` (VSCode pack auto-loaded).
- Blink owns signature help and insert-mode `<C-j>/<C-k>` completion/snippet navigation; keep Noice signatures disabled.
- Add new sources via `opts.sources.default` in `lua/plugins/completion.lua` — do not pull `cmp-*` source plugins
