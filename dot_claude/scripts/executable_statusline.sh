#!/bin/bash
# Combined statusline: model | context % | caveman badge

INPUT=$(cat)

MODEL=$(printf '%s' "$INPUT" | jq -r '.model.display_name // "Claude"')
PCT=$(printf '%s' "$INPUT" | jq -r '(.context_window.used_percentage // 0) | floor')
printf '%s | %s%% ctx' "$MODEL" "$PCT"
