# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).
Targeting CachyOS (Arch) and Ubuntu. Compositor: [Niri](https://github.com/YaLTeR/niri).

## Install

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply Mikel-Landa
```

## What's included

| Config | Tool |
|--------|------|
| `dot_config/nvim/` | Neovim — Lazy.nvim, LSP via Mason, blink.cmp, matugen colorscheme |
| `dot_config/niri/` | Niri — Wayland compositor config, keybinds, autostart |
| `dot_config/kitty/` | Kitty — terminal emulator |
| `dot_config/matugen/` | Matugen — wallpaper-adaptive color generation for kitty + nvim |
| `dot_config/sheldon/` | Sheldon — zsh plugin manager (cached source) |
| `dot_config/metapac/` | Metapac — declarative package management |
| `dot_config/zsh/` | Zsh — vi mode, p10k, autoload functions |
| `dot_zshrc` | Zsh entrypoint |
| `dot_config/tmux/` | Tmux config |
| `dot_config/git/` | Git — GPG signing, column UI, branch sorting |
| `dot_config/curlrc` | Curl defaults |

## Package management

Packages declared in `dot_config/metapac/groups/`. See [`metapac/AGENTS.md`](dot_config/metapac/AGENTS.md) for the group breakdown and rules.

## Colors

[Matugen](https://github.com/InioX/matugen) generates a Material You palette from the current wallpaper and writes color configs for Kitty and Neovim. To regenerate:

```bash
matugen image /path/to/wallpaper.jpg
```

## Git configuration

Personal/work split via `includeIf`:

- `~/.config/git/config-personal` — default for all repos
- `~/.config/git/config-work` — applied for repos under `~/repos/` (local-only, not in repo)
