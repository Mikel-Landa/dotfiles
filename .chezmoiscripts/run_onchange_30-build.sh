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
metapac_bin="$metapac_src/target/release/metapac"
metapac_head=$(git -C "$metapac_src" rev-parse HEAD)
metapac_built_marker="$metapac_src/target/.built-rev"
if [ ! -x "$metapac_bin" ] || [ ! -f "$metapac_built_marker" ] || [ "$(cat "$metapac_built_marker")" != "$metapac_head" ]; then
    (cd "$metapac_src" && cargo build --release)
    printf '%s' "$metapac_head" > "$metapac_built_marker"
fi
ln -sf "$metapac_bin" "$HOME/bin/metapac"

# tmux plugin manager.
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    mkdir -p "$HOME/.tmux/plugins"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
