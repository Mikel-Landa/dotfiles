# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Installation

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply Mikel-Landa
```

## Git Configuration

This dotfiles setup uses separate git configurations for personal and work repositories:

- **Personal**: `~/.gitconfig-personal` - Used for all repositories by default
- **Work**: `~/.gitconfig-work` - Used for repositories under `~/repos/`

The main `~/.gitconfig` includes both configurations conditionally:
- Personal config is always included
- Work config is included only for repositories in `~/repos/`