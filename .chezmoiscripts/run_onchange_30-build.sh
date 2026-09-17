#!/usr/bin/env bash
# Phase 30 — build. Compile / clone things that aren't packaged.
# Idempotent: clones only if missing; pulls + rebuilds if source updated.

set -euo pipefail

# Make cargo available (rustup installed in phase 10).
[ -r "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# metapac — pinned to dev branch on personal fork. Rebuild when source changes.
mkdir -p "$HOME/personal" "$HOME/bin"
metapac_src="$HOME/personal/metapac"
if [ ! -d "$metapac_src/.git" ]; then
    git clone git@github.com:Mikel-Landa/metapac.git "$metapac_src"
    git -C "$metapac_src" checkout metapac-go
fi
git -C "$metapac_src" pull --ff-only || true
# Ask Cargo so environment overrides and .cargo/config.toml are both respected.
metapac_target=$(cd "$metapac_src" && cargo metadata --no-deps --format-version 1 | jq -er '.target_directory')
metapac_bin="$metapac_target/release/metapac"
metapac_head=$(git -C "$metapac_src" rev-parse HEAD)
metapac_built_marker="$metapac_target/.metapac-built-rev"
if [ ! -x "$metapac_bin" ] || [ ! -f "$metapac_built_marker" ] || [ "$(cat "$metapac_built_marker")" != "$metapac_head" ]; then
    (cd "$metapac_src" && cargo build --release)
    printf '%s' "$metapac_head" > "$metapac_built_marker"
fi
ln -sf "$metapac_bin" "$HOME/bin/metapac"

# tmux plugin manager.
tpm_dir="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$tpm_dir" ]; then
    mkdir -p "${tpm_dir%/*}"
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
fi
