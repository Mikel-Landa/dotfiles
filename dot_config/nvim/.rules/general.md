# General Rules

- Lua only — no Vimscript.
- Prefer built-in Neovim APIs over plugin abstractions when trivial: `vim.api.*` over `vim.fn.*` when both exist (faster, no eval); `vim.system()` (0.10+) over `vim.fn.jobstart()`.
- Don't reinstall built-ins: `gc`/`gcc` commenting (0.10+), `vim.snippet` (0.10+), `vim.lsp.inlay_hint`, treesitter syntax — all built into nvim. Skip plugins like `Comment.nvim` unless you need a feature the built-in lacks.
- Keep `lazy-lock.json` in chezmoi source control. After intentional plugin changes, capture the deployed lockfile with `chezmoi re-add ~/.config/nvim/lazy-lock.json`. Use `:Lazy restore` to reproduce locked versions; `:Lazy update` intentionally advances them.
- `:checkhealth` is the first debug step. `:checkhealth lazy` / `:checkhealth lsp` for scoped checks.

## Lightweight bar

Goal: **<80 ms startup** measured with `nvim --startuptime /tmp/start.log`. Audit with `:Lazy profile` (sorts loaded plugins by load time).

Kept lean by:
- Follow each plugin's loading requirements; treesitter, Snacks and fff load eagerly as their maintainers recommend.
- One completion engine (`blink.cmp`) — never run two.
- One file explorer, one fuzzy finder, one statusline. Resist alternatives.
- No file-tree-on-startup, no animation/scrollbar/UI-reskin plugins.

Before adding a plugin, check: does a built-in or already-installed plugin do this? Could 10 lines of Lua replace it?

## Anti-patterns

- Set eager-load priorities only for documented ordering needs, such as colorschemes and Snacks (`priority = 1000`).
- Use `lazy = false` when the plugin requires startup setup or manages its own lazy initialization; document the reason.
- `dependencies = { "X" }` when X is a sibling plugin (use `dependencies` only for runtime requirements that must load first).
- Empty `config = function() require("p").setup({}) end` — replace with `opts = {}`.
- `BufEnter`/`BufWinEnter` lazy triggers — fire on every buffer switch.
- Plugin specs scattered across `init.lua` — keep them in `lua/plugins/`.
