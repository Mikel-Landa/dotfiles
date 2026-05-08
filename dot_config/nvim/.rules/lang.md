# Per-language bundles (`lua/plugins/lang/`)

LazyVim-style: one file per language owns its **LSP server**, **formatter**, **linter**, **DAP adapter**, **treesitter parser**, and any **language-specific plugins**. Each lang file is a list of `optional = true` specs that merge into the base specs via lazy.nvim opts merging.

## Preferred workflow: copy from LazyVim

LazyVim already ships per-language bundles ("extras") for ~40 languages. **Copy from those first**, then port to our manual setup — don't reinvent the settings table from scratch.

- Browse the catalog: <https://github.com/LazyVim/LazyVim/tree/main/lua/lazyvim/plugins/extras/lang>
- Raw file URL pattern: `https://raw.githubusercontent.com/LazyVim/LazyVim/main/lua/lazyvim/plugins/extras/lang/<NAME>.lua`
- Some languages live in subfolders (`typescript/init.lua`, `typescript/vtsls.lua`, etc.).

## Porting checklist (LazyVim → this repo)

When transcribing an extra:

1. **Drop LazyVim helpers** — `LazyVim.opts(...)`, `LazyVim.has(...)`, `LazyVim.lsp.action[...]`, `LazyVim.lsp.execute(...)`, `recommended = function() ... end`. Replace with vanilla equivalents (`vim.lsp.buf.code_action({ apply = true, context = {...} })`, plain `vim.keymap.set` in our `LspAttach` hook, plain `pcall(require, …)` for soft deps).
2. **Mason package names**: LazyVim sometimes lists tools under `nvim-treesitter` or `none-ls`; we route everything through `mason-tool-installer`'s `ensure_installed`.
3. **DAP**: LazyVim wires DAP inside the lang file via a `nvim-dap` spec that adds adapters/configurations in `config = function()`. We do the same.
4. **`keys` on a server entry** is our convention — it's a `function(client, bufnr)` that runs from our `LspAttach` hook in `lsp.lua`. LazyVim uses a list of keymap tables there; convert to our function form.
5. Mark every spec `optional = true` so the file is a no-op if the base plugin is removed.

## Steps

1. Create `lua/plugins/lang/<name>.lua` returning a list of specs.
2. Extend the relevant base specs (each `optional = true`):
   - `WhoIsSethDaniel/mason-tool-installer.nvim` → append to `opts.ensure_installed` via **function-form opts** (see below).
   - `nvim-treesitter/nvim-treesitter` → append to `opts.ensure_install` via **function-form opts**.
   - `neovim/nvim-lspconfig` → `opts.servers.<name> = { settings = …, keys = function(client, bufnr) … end }` (table form OK — dict-keyed).
   - `stevearc/conform.nvim` → `opts.formatters_by_ft` and `opts.formatters` for tweaks (table form OK — dict-keyed).
   - `mfussenegger/nvim-lint` → `opts.linters_by_ft` (table form OK — dict-keyed).
   - `mfussenegger/nvim-dap` → `opts = function() … end` (NOT `config`) that adds `dap.adapters.<name>` and appends to `dap.configurations[ft]`. lazy.nvim runs `opts` from every spec and merges, but only one `config` per plugin — using `config` here would silently overwrite other lang files' DAP setup.
3. Add language-specific plugins (e.g. `rustaceanvim`, `crates.nvim`, `dap-go`) as additional specs in the same file.
4. Update `docs/plugins.md` and `docs/keymaps.md`.

### Function-form opts for list keys (mandatory)

lazy.nvim merges spec `opts` via `vim.tbl_deep_extend("force", …)`, which **replaces** integer-indexed lists rather than concatenating them. Two table-form specs both setting `opts.ensure_installed = {…}` → only one wins, the rest silently lost. Bug surfaces as "Mason never installed my Go tools".

For any list-valued opt (`ensure_installed`, `ensure_install`, …) use function form so each lang file appends:

```lua
{
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  optional = true,
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    vim.list_extend(opts.ensure_installed, { "gofumpt", "goimports", … })
  end,
},
```

Dict-keyed opts (`servers`, `formatters_by_ft`, `linters_by_ft`) are safe in table form because each lang sets a distinct key.

## Example: minimal new language

Adding Zig from <https://raw.githubusercontent.com/LazyVim/LazyVim/main/lua/lazyvim/plugins/extras/lang/zig.lua>:

```lua
-- lua/plugins/lang/zig.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      opts.ensure_install = opts.ensure_install or {}
      vim.list_extend(opts.ensure_install, { "zig" })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "zls" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        zls = {
          settings = {
            zls = {
              enable_inlay_hints = true,
              warn_style = true,
            },
          },
        },
      },
    },
  },
}
```

Existing language files (use as templates): `lua.lua`, `python.lua`, `typescript.lua`, `rust.lua`, `go.lua`, `clangd.lua`, `markdown.lua`, `bash.lua`.

Base specs (the things lang files extend) live in: `lsp.lua`, `treesitter.lua`, `formatting.lua`, `lint.lua`, `dap.lua`. They contain *only* base wiring — no language-specific entries.
