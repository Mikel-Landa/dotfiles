#!/bin/bash
# Combined statusline: model | context % | caveman badge

INPUT=$(cat)

MODEL=$(printf '%s' "$INPUT" | jq -r '.model.display_name // "Claude"')
PCT=$(printf '%s' "$INPUT" | jq -r '(.context_window.used_percentage // 0) | floor')

CAVEMAN=$(bash "/home/mikel/.claude/plugins/cache/caveman/caveman/84cc3c14fa1e/hooks/caveman-statusline.sh" <<< "$INPUT")

printf '%s | %s%% ctx' "$MODEL" "$PCT"
[ -n "$CAVEMAN" ] && printf ' %s' "$CAVEMAN"
