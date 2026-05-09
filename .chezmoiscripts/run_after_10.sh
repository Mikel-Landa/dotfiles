#!/usr/bin/env bash
# Phase 40 — sync. Apply package manifests via metapac.
# metapac handles its own idempotency.

set -euo pipefail

if [ ! -x "$HOME/bin/metapac" ]; then
    echo "phase 40 (sync): metapac not found at ~/bin/metapac — phase 30 should have built it" >&2
    exit 1
fi

"$HOME/bin/metapac" sync
