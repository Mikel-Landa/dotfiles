# Chezmoi Dotfiles

This repo manages dotfiles via chezmoi. Files prefixed `dot_` map to `~/.` on the target system.

## Before Modifying Any Folder

Check if the target folder contains its own `AGENTS.md` and follow it. Folder-level instructions take precedence for that scope.

Known AGENTS.md locations:
- [dot_agents/AGENTS.md](dot_agents/AGENTS.md) — shared agent file-search rules
- [dot_agents/skills/rust-skills/AGENTS.md](dot_agents/skills/rust-skills/AGENTS.md) — supplementary Rust guidance for gaps in `rust-guidelines`
- [dot_codex/AGENTS.md](dot_codex/AGENTS.md) — Codex global instructions
- [dot_config/metapac/AGENTS.md](dot_config/metapac/AGENTS.md) — package management rules
- [dot_config/nvim/AGENTS.md](dot_config/nvim/AGENTS.md) — Neovim config rules

## Maintaining This File

When creating, moving, or deleting an `AGENTS.md` anywhere in this repo, update the list above.
