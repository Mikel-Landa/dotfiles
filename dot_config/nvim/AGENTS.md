# Neovim Config — Agent Guidelines

Plugin manager: **lazy.nvim**. Entry point: `init.lua`.

## Docs maintenance (mandatory)

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

## Folder Structure

```
~/.config/nvim/
├── init.lua                  # Bootstrap lazy.nvim + require config/* + setup plugins
├── lazy-lock.json            # Lockfile — commit this
├── README.md                 # User-facing entry point, links into docs/
├── AGENTS.md                 # This file
├── docs/                     # User docs (plugins, keymaps, vim essentials)
├── ftplugin/                 # OPTIONAL: per-filetype settings (created on demand)
│   └── <ft>.lua              #   e.g. python.lua → opt_local.shiftwidth = 4
└── lua/
    ├── config/
    │   ├── options.lua       # Global option settings
    │   ├── keymaps.lua       # Global keymaps + mapleader
    │   └── autocmds.lua      # Autocommands + diagnostic.config()
    └── plugins/
        └── *.lua             # One file per domain (lsp.lua, ui.lua, editing.lua…)
```

- `ftplugin/<ft>.lua` is the idiomatic place for filetype options — it auto-loads on `FileType` and uses `opt_local`. Prefer over a sprawling `autocmds.lua` `FileType` block.
- No `after/` unless load-order conflict is proven (it's for overriding plugin defaults).
- No `plugin/` (that's for plugin authors).
- No single monolithic plugin file — group by domain.

## Adding Plugins

All plugin specs live in `lua/plugins/*.lua`. Lazy auto-discovers all files there.

Each file returns a table:

```lua
return {
  {
    "author/plugin-name",
    event = "VeryLazy",      -- lazy-load; pick most specific trigger
    opts = {                 -- prefer opts= over config=
      key = "value",
    },
  },
}
```

**Versioning**: track the plugin's default branch (no `version`/`branch` field). Pin only when the plugin author publishes semver tags AND breaks things between majors (e.g. `nvim-surround` → `version = "*"`). `lazy-lock.json` already pins exact commits — that's your real safety net. Blanket `version = "*"` on a plugin with no tags silently degrades to "latest commit" anyway.

**Lazy-loading triggers** (pick the most specific):

| Trigger | When to use |
|---|---|
| `event = "VeryLazy"` | UI/editing plugins that can wait until after first draw |
| `event = { "BufReadPre", "BufNewFile" }` | File-content plugins (LSP, gitsigns, indent guides) |
| `cmd = { "CmdName" }` | Plugins only needed via an Ex command |
| `ft = { "lua", "python" }` | Filetype-specific plugins |
| `keys = { ... }` | Plugins triggered only by keymaps (lazy.nvim auto-creates the stub) |
| `lazy = false` | **Avoid** — only colorscheme, treesitter, and snacks.nvim (provides core APIs: `vim.notify`, `vim.ui.input`, statuscolumn) need it |

Don't use `BufEnter`/`BufWinEnter` — they fire on every buffer switch and tank perf. `BufReadPre`+`BufNewFile` is the canonical "file is open" pair.

**Prefer `opts = {}` over `config = function()`** unless setup logic is non-trivial. Lazy merges `opts` tables from multiple specs automatically. For dynamic opts use the function form: `opts = function(_, opts) opts.x = ... ; return opts end`.

```lua
-- good
opts = { timeout = 500 }

-- only when opts= is insufficient
config = function(_, opts)
  require("plugin").setup(opts)
  -- extra imperative setup here
end
```

## Keymaps

Leader: `<Space>` (set in `lua/config/keymaps.lua`).

Always use `vim.keymap.set`, always provide `desc`:

```lua
vim.keymap.set("n", "<leader>xx", function() ... end, { desc = "Short description" })
```

**Leader group conventions** (follow existing layout):

| Prefix | Domain |
|---|---|
| `<leader>f` | Find (snacks.picker) |
| `<leader>b` | Buffers |
| `<leader>g` | Git / hunks (gitsigns + snacks.picker) |
| `<leader>gt` | Git toggles (inline blame, deleted, word diff) |
| `<leader>gv` | Diffview |
| `<leader>l` | LSP (symbols, etc.) |
| `<leader>d` | Diagnostics (`<leader>dd` = float) |
| `<leader>x` | Trouble panel (diagnostics/symbols/refs) |
| `<leader>u` | UI toggles (`<leader>uh` = inlay hints, `<leader>un` = dismiss notif) |
| `<leader>c` | Code (action, format) |
| `<leader>r` | Rename / refactor |
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

## Options

Set globals in `lua/config/options.lua`. Two APIs:

- `vim.opt.x = ...` — table interface, supports `:append`/`:prepend`/`:remove` for list/map options. Use for `shortmess`, `wildignore`, `formatoptions`, etc.
- `vim.o.x = ...` — plain scalar setter. Slightly faster, fine for `shiftwidth`, `number`, `relativenumber`, etc.

Pick the simpler one. The codebase uses `vim.opt` consistently — keep that, but don't religiously avoid `vim.o`.

Filetype-specific overrides → `ftplugin/<ft>.lua` with `vim.opt_local` (auto-loaded by nvim on `FileType`). Avoid putting filetype branching in `autocmds.lua`.

## LSP

- Server install: `mason.nvim` (binary), bridged by `mason-lspconfig.nvim`. Add a server name to the `servers` table in `lua/plugins/lsp.lua` — mason auto-installs it.
- Per-server config in the same `servers` table (settings/init_options live with the server entry).
- Use the **0.11+ API**: `vim.lsp.config(name, cfg)` + `vim.lsp.enable(name)`. Do not call `require("lspconfig").<server>.setup()` (legacy path).
- Attach keymaps inside an `LspAttach` autocmd, scoped with `buffer = event.buf`.
- Capabilities sourced from `blink.cmp` (`require("blink.cmp").get_lsp_capabilities()`).
- JSON / YAML schemas auto-injected via `b0o/SchemaStore.nvim` — do **not** hand-write schemas.
- Use `vim.lsp.buf.*` and `client:supports_method(...)` (colon, not dot — dot form deprecated in 0.11+).
- `mason-lspconfig` v2 renamed `automatic_installation` → `automatic_enable`. Migrate when bumping the plugin.

## Formatters / Linters / DAPs

Mason installs more than LSPs — also formatters (`stylua`, `prettierd`, `ruff`), linters (`shellcheck`, `eslint_d`), and DAP adapters. Install via `:Mason` UI or `:MasonInstall <name>`. Wire formatters into `conform.nvim` (`lua/plugins/formatting.lua`); linters into `nvim-lint` (not installed — add only when an LSP doesn't cover the language).

Don't add `mason-tool-installer` etc. unless the install list grows past ~5 non-LSP tools.

## Completion

- `blink.cmp` (replaces nvim-cmp). Single plugin; sources `lsp / snippets / path / buffer` built-in
- Snippets: `LuaSnip` + `friendly-snippets` (vscode pack auto-loaded)
- Add new sources via `opts.sources.default` in `lua/plugins/completion.lua` — do not pull `cmp-*` source plugins

## Diagnostics

- VSCode-style: `underline` on (red undercurl), `virtual_text` off, signs in gutter — config in `lua/config/autocmds.lua`
- Float auto-opens on `CursorHold` (`updatetime = 250`) at cursor scope; suppressed if any other float is open
- Manual float: `<leader>dd`. Panel: `<leader>xx` (Trouble)
- Tmux requires `Smulx` + `Setulc` in `terminal-overrides` for colored undercurl — see `~/.tmux.conf`

## Treesitter

Parsers declared in `lua/plugins/treesitter.lua` inside the `install({...})` call (new `main` branch API — not `ensure_installed`). Add new languages there, not elsewhere.

## General Rules

- Lua only — no Vimscript.
- Prefer built-in Neovim APIs over plugin abstractions when trivial: `vim.api.*` over `vim.fn.*` when both exist (faster, no eval); `vim.system()` (0.10+) over `vim.fn.jobstart()`.
- Don't reinstall built-ins: `gc`/`gcc` commenting (0.10+), `vim.snippet` (0.10+), `vim.lsp.inlay_hint`, treesitter syntax — all built into nvim. Skip plugins like `Comment.nvim` unless you need a feature the built-in lacks.
- Commit `lazy-lock.json`. Update with `:Lazy update`; install/remove with `:Lazy sync`.
- `:checkhealth` is the first debug step. `:checkhealth lazy` / `:checkhealth lsp` for scoped checks.

## Lightweight bar

Goal: **<80 ms startup** measured with `nvim --startuptime /tmp/start.log`. Audit with `:Lazy profile` (sorts loaded plugins by load time).

Kept lean by:
- Lazy-loading aggressively (only colorscheme + treesitter eager-load).
- One completion engine (`blink.cmp`) — never run two.
- One file explorer, one fuzzy finder, one statusline. Resist alternatives.
- No file-tree-on-startup, no animation/scrollbar/UI-reskin plugins.

Before adding a plugin, check: does a built-in or already-installed plugin do this? Could 10 lines of Lua replace it?

## Anti-patterns

- `priority = 1000` on anything but the colorscheme — breaks lazy ordering.
- `lazy = false` without justification — defeats the loader. Acceptable only for colorscheme + treesitter.
- `dependencies = { "X" }` when X is a sibling plugin (use `dependencies` only for runtime requirements that must load first).
- Empty `config = function() require("p").setup({}) end` — replace with `opts = {}`.
- `BufEnter`/`BufWinEnter` lazy triggers — fire on every buffer switch.
- Plugin specs scattered across `init.lua` — keep them in `lua/plugins/`.
