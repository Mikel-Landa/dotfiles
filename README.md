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
| `dot_agents/`, `dot_claude/` | Shared skills, Claude instructions, preferences and custom hooks |
| `dot_omp/` | OMP model roles, tools, UI and skill discovery preferences |
| `dot_codex/` | Codex instructions and portable initial preferences |
| `dot_gsd/` | GSD user defaults |
| `dot_config/mise/`, `dot_config/gh/` | Tool versions and GitHub CLI preferences |
| `dot_config/private_Code/` | VS Code initial preferences, keybindings and snippets |

## Portable agent configuration

Commit preferences and authored skills/scripts, not credentials, sessions, caches,
project trust grants, onboarding consent, or installed package output.
Use `chezmoi add` on selected files rather than whole application directories.
SurfingKeys is intentionally excluded.

Claude's GSD hooks require the complete runtime. Phase 40 installs
`@opengsd/gsd-core@1.7.0` with the full Claude profile through mise's Node 24,
before chezmoi overlays the custom settings. Scripts retain their
`.chezmoiscripts/` target prefix, which sorts before `.claude/`; phase numbers
order the prerequisite and runtime scripts within that directory. First apply
needs network access. GSD's generated agents, skills, hooks and runtime are
installed, not vendored.
The shared Rust skill keeps its rules/references, not its upstream CI/check harness.

Codex `config.toml` and VS Code `settings.json` use chezmoi's `create_` attribute:
they initialize a new system but leave an existing file untouched. Their source
copies omit tokens, machine paths and application-generated state. Apply their
preferences manually on an already-configured system if desired. Codex's GSD
installation, desktop integrations and plugin installations remain local.

OMP authentication, Codex authentication, Claude credentials, GitHub `hosts.yml`,
shell secrets and machine-specific cloud/SSH credentials must be set up locally.
OMP's copied preferences retain the current `yolo` approval mode; onboarding and
telemetry consent are not copied. Install/login to each application separately.

To check the real bootstrap/application order in an isolated home:

```bash
python3 tests/test_claude_bootstrap.py
```

This requires chezmoi, mise and network access. It runs the pinned installer
through `chezmoi apply` and checks that the final Claude settings match the
managed configuration, including after a second apply.

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
