#!/usr/bin/env bash
# Install the package-owned GSD runtime before chezmoi overlays Claude preferences.
# Phase 10 provides mise; Node 24 satisfies GSD's Node >=22 / npm >=10 requirement.
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"
mise exec --yes node@24 -- npx --yes --package=@opengsd/gsd-core@1.7.0 -- \
    gsd-core --claude --global --profile=full --portable-hooks
