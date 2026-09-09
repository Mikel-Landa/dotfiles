#!/usr/bin/env bash
# Phase 10 — prereqs. OS-portable. All steps idempotent.
# Toolchains needed by later phases: rustup, cargo-binstall, mise.

set -euo pipefail

if ! command -v rustc >/dev/null 2>&1 && ! command -v cargo >/dev/null 2>&1; then
    curl -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

# Make cargo available in this shell so cargo-binstall install works below.
[ -r "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

if ! command -v cargo-binstall >/dev/null 2>&1; then
    cargo install cargo-binstall
fi

if ! command -v mise >/dev/null 2>&1; then
    curl -sSf https://mise.run | sh
fi
