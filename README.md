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
| `dot_config/gh/` | GitHub CLI preferences |
| `dot_config/private_Code/` | VS Code initial preferences, keybindings and snippets |

## Portable agent configuration

Commit preferences and authored skills/scripts, not credentials, sessions, caches,
project trust grants, onboarding consent, or installed package output.
Use `chezmoi add` on selected files rather than whole application directories.
SurfingKeys is intentionally excluded.

The shared Rust skill keeps its rules/references, not its upstream CI/check harness.

Codex `config.toml` and VS Code `settings.json` use chezmoi's `create_` attribute:
they initialize a new system but leave an existing file untouched. Their source
copies omit tokens, machine paths and application-generated state. Apply their
preferences manually on an already-configured system if desired. Codex's
desktop integrations and plugin installations remain local.

OMP authentication, Codex authentication, Claude credentials, GitHub `hosts.yml`,
shell secrets and machine-specific cloud/SSH credentials must be set up locally.
OMP's copied preferences retain the current `yolo` approval mode; onboarding and
telemetry consent are not copied. Install/login to each application separately.

## Package management

Packages declared in `dot_config/metapac/groups/`. See [`metapac/AGENTS.md`](dot_config/metapac/AGENTS.md) for the group breakdown and rules.

Metapac is the source of truth for cross-PC packages, including mise tools.
`~/.config/mise/` is local-only and excluded from chezmoi.

Metapac bootstrap reads Cargo metadata to locate build output, respecting
`CARGO_TARGET_DIR` and Cargo's `build.target-dir` configuration. Existing compiler
wrappers such as sccache remain unchanged.

## Colors

[Matugen](https://github.com/InioX/matugen) generates a Material You palette from the current wallpaper and writes color configs for Kitty and Neovim. To regenerate:

```bash
matugen image /path/to/wallpaper.jpg
```

## Git configuration

Identity follows this include order:

1. `~/.config/git/config-personal` sets the default personal email and signing key.
2. `~/.config/git/config-work`, when present, overrides both (local-only).
3. Repositories under `~/personal/`, including their linked worktrees, override
   both back to the personal identity.

Personal PCs without a work config use personal identity everywhere. Work laptops
use work identity except in personal repositories. The user setup script creates
the work config only when chezmoi's `work` setting is true. Provision the personal
secret key locally.

## Shell workflow

- **Ctrl-R** searches history; **Ctrl-T** inserts paths with file/tree previews;
  **Alt-C** picks a directory with a tree preview. Searches respect `.gitignore`,
  include dotfiles, and skip `.git`, `node_modules`, `target`, and `.venv`.
- `fcd` changes directory, `f` copies a file path, and `fv` opens a file in the
  editor. Escape leaves the current directory, clipboard, and editor untouched.
- `kcfg` selects a file in `~/.kube`; Escape preserves `KUBECONFIG`.
- `uclip` copies stdin through WSL, Wayland, X11, or macOS. Missing clipboard
  support produces an error. `f` uses the same helper.
- `cat` uses bat with automatic colors/paging, keeping redirected output plain.
- Zsh caches generated tool initialization by executable path/metadata and
  arguments, resolving mise shims to their selected binaries. Tool changes
  regenerate initialization; `ZSH_EVALCACHE_DISABLE=true` bypasses caching.
  `_evalcache_clear` removes cached initialization interactively.

## Project sessions

Tmux **prefix + Space** opens `code-session --pick`: projects under `~/repos/`,
ordered by zoxide history then filesystem discovery, plus their linked worktrees.
Full paths distinguish projects with identical directory names. Use
`code-session --pick ~/personal` for personal projects, or `code-session PATH`
directly. Escape opens no session. Session names combine directory name and a
canonical-path hash; symlinks to the same directory reuse its session.

TPM installs and loads from `~/.config/tmux/plugins/tpm`. After bootstrap, use
**prefix + I** to install configured plugins.
