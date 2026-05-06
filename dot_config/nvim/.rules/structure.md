# Folder Structure

```
~/.config/nvim/
├── init.lua                  # Bootstrap lazy.nvim + require config/* + setup plugins
├── lazy-lock.json            # Lockfile — commit this
├── README.md                 # User-facing entry point, links into docs/
├── AGENTS.md                 # Index + chezmoi rule
├── .rules/                   # Per-topic agent rules
├── docs/                     # User docs (plugins, keymaps, vim essentials)
├── ftplugin/                 # OPTIONAL: per-filetype settings (created on demand)
│   └── <ft>.lua              #   e.g. python.lua → opt_local.shiftwidth = 4
└── lua/
    ├── config/
    │   ├── options.lua       # Global option settings
    │   ├── keymaps.lua       # Global keymaps + mapleader
    │   └── autocmds.lua      # Autocommands + diagnostic.config()
    └── plugins/
        ├── *.lua             # One file per domain (lsp.lua, ui.lua, editing.lua, dap.lua…)
        └── lang/             # One file per language (LazyVim-style language bundles)
            └── <name>.lua    #   e.g. python.lua, rust.lua, go.lua
```

- `ftplugin/<ft>.lua` is the idiomatic place for filetype options — it auto-loads on `FileType` and uses `opt_local`. Prefer over a sprawling `autocmds.lua` `FileType` block.
- No `after/` unless load-order conflict is proven (it's for overriding plugin defaults).
- No `plugin/` (that's for plugin authors).
- No single monolithic plugin file — group by domain.
