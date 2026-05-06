# General Rules

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
