# Neovim Config

Personal Neovim setup. Lazy-loaded plugins, LSP via mason, blink.cmp completion, catppuccin theme.

## Docs

- [Plugins](docs/plugins.md) — installed plugins, what they do, how to use them
- [Keymaps](docs/keymaps.md) — leader-prefixed keybinds defined in this config
- [Vim Essentials](docs/vim-essentials.md) — built-in motions/commands worth knowing

## Quick start

1. Open Neovim. Lazy.nvim bootstraps on first launch.
2. Wait for `:Lazy` to install plugins, `:Mason` to install language servers.
3. Run `:checkhealth` to verify everything is green.

## Layout

```
init.lua              # bootstrap + load config
lua/config/           # options, keymaps, autocmds
lua/plugins/          # one file per domain
ftplugin/             # per-filetype overrides
docs/                 # user docs (this folder's siblings)
AGENTS.md             # contributor / agent guidelines
```

Leader is `<Space>`.
