# Metapac — Package Source of Truth

Metapac is the single source of truth for all installed packages. When adding a package to any system, add it here first.

## Group Overview

| File | Purpose | Committed |
|------|---------|-----------|
| `base.toml` | Core CLI utilities (git, curl, gcc, etc.) — cross-platform | yes |
| `terminal.toml` | Terminal tools (neovim, zsh, tmux, ripgrep, etc.) — cross-platform | yes |
| `apps.toml` | GUI applications (VSCode, Chrome, Spotify) | yes |
| `niri.toml` | Niri compositor extras | yes |
| `kubernetes.toml` | Kubernetes tooling | yes |
| `work.toml` | Work-only tools | yes |
| `system.toml` | **System-specific packages — gitignored, never commit** | no |

## Where to Add Packages

**Should exist on every machine** → `base.toml` or `terminal.toml`
- Add both `arch` and `apt` entries if the package exists on both
- Use `cargo`/`mise`/`go` backends for cross-distro installs

**GUI apps** → `apps.toml`

**Niri-specific** → `niri.toml`

**Work tools** → `work.toml`

**System/distro-specific packages** → `system.toml` only
- `system.toml` is gitignored — changes stay local, never propagate to other machines
- Hardware drivers, distro-specific utilities, kernel variants, OS defaults belong here
- Applies regardless of OS: CachyOS packages, Ubuntu system packages, etc.

## Backends

Configured in `config.toml`:
- Global: `cargo`, `mise`, `go`
- `cachyos` hostname: also `arch` (paru)
- `work-ifs` hostname: also `apt`

## Rules

1. Never add system/distro-specific packages to committed group files — use `system.toml`
2. Prefer `cargo`/`mise`/`go` backends for tools that should be portable
3. When a tool exists in `system.toml` AND should be on other machines, move it to the right committed group
4. `apt` entries required in `base.toml` and `terminal.toml` for work machine compatibility
