# Neovim Config

Personal Neovim setup. Lazy-loaded plugins, LSP via mason, blink.cmp completion, catppuccin theme.

## Docs

- [Plugins](docs/plugins.md) — installed plugins, what they do, how to use them
- [Keymaps](docs/keymaps.md) — leader-prefixed keybinds defined in this config
- [Vim Essentials](docs/vim-essentials.md) — built-in motions/commands worth knowing

## Quick start

1. Use Neovim 0.12+ and tree-sitter CLI 0.26.1+. Open Neovim; lazy.nvim bootstraps on first launch.
2. Wait for `:Lazy` to install plugins, `:Mason` to install language servers.
3. Run `:checkhealth` to verify dependencies. Use `:Lazy restore` to reproduce the tracked plugin versions.

After intentional plugin updates, run `chezmoi re-add ~/.config/nvim/lazy-lock.json` and commit the updated lockfile with the configuration.

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

Clipboard sync uses tmux directly on WSL inside tmux, and Windows' built-in
`clip.exe` / `powershell.exe` outside it. This skips slow provider discovery on
Windows-mounted paths. Normal Linux keeps automatic Wayland/X11 detection.
