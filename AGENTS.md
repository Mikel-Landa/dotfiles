# Chezmoi Dotfiles

This repo manages dotfiles via chezmoi. Files prefixed `dot_` map to `~/.` on the target system.

## Before Modifying Any Folder

Check if the target folder contains its own `AGENTS.md` and follow it. Folder-level instructions take precedence for that scope.

Known AGENTS.md locations:
- `dot_config/metapac/AGENTS.md` — package management rules
- `dot_config/nvim/AGENTS.md` — neovim config rules

## Maintaining This File

When creating a new `AGENTS.md` anywhere in this repo, add it to the list above.
