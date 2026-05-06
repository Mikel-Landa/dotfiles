# Adding Plugins

All plugin specs live in `lua/plugins/*.lua` (top-level domain files) or `lua/plugins/lang/*.lua` (per-language bundles). `init.lua` imports both folders explicitly via `{ import = "plugins" }` and `{ import = "plugins.lang" }` — lazy.nvim does **not** recurse into subdirectories on its own, so any new sibling folder under `lua/plugins/` needs its own `import` line.

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
