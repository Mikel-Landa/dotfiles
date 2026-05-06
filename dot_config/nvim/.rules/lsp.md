# LSP

- Use the **0.11+ API**: `vim.lsp.config(name, cfg)` + `vim.lsp.enable(name)`. Do not call `require("lspconfig").<server>.setup()` (legacy path).
- Attach keymaps inside an `LspAttach` autocmd, scoped with `buffer = event.buf`.
- Capabilities sourced from `blink.cmp` (`require("blink.cmp").get_lsp_capabilities()`).
- JSON / YAML schemas auto-injected via `b0o/SchemaStore.nvim` — do **not** hand-write schemas.
- Use `vim.lsp.buf.*` and `client:supports_method(...)` (colon, not dot — dot form deprecated in 0.11+).
- `mason-lspconfig`'s auto-enable is **disabled** — `lua/plugins/lsp.lua` calls `vim.lsp.enable(...)` itself with the merged `opts.servers` from all spec files. Adds an opt-out for stale installs (e.g. ts_ls left over after a vtsls switch).
