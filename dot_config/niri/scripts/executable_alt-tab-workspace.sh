#!/usr/bin/env bash
# MRU workspace cycler for Alt+Tab.
# Hold Alt, tap Tab to cycle forward through workspaces in MRU order.
# Wraps back to starting workspace at end of list.
# Alt release is detected by alt-watcher.py which commits state immediately.

STATE_FILE="/tmp/niri-workspace-mru"
SESSION_FILE="/tmp/niri-altab-session"

current=$(niri msg workspaces | awk '/^\s*\*/ {
    gsub(/[*]/, ""); gsub(/^ +/, "")
    if ($2 != "") { gsub(/"/, "", $2); print $2 }
    else { print $1 }
}')

now_ms=$(date +%s%3N)

if [[ -f "$SESSION_FILE" ]]; then
    pos=$(sed -n '2p' "$SESSION_FILE")
    mapfile -t snap < <(tail -n +3 "$SESSION_FILE")
    count=${#snap[@]}
    pos=$(( pos + 1 ))
    (( pos >= count )) && pos=0
    next="${snap[$pos]}"
    { echo "$now_ms"; echo "$pos"; printf '%s\n' "${snap[@]}"; } > "$SESSION_FILE"
else
    if [[ ! -f "$STATE_FILE" ]] || [[ $(wc -l < "$STATE_FILE") -lt 2 ]]; then
        niri msg action focus-workspace-down
        exit 0
    fi
    mapfile -t hist < "$STATE_FILE"

    # Rotate so current workspace is at index 0
    start=0
    for i in "${!hist[@]}"; do
        [[ "${hist[$i]}" == "$current" ]] && start=$i && break
    done
    snap=("${hist[@]:$start}" "${hist[@]:0:$start}")

    if (( ${#snap[@]} < 2 )); then
        niri msg action focus-workspace-down
        exit 0
    fi

    pos=1
    next="${snap[1]}"
    { echo "$now_ms"; echo "$pos"; printf '%s\n' "${snap[@]}"; } > "$SESSION_FILE"
fi

niri msg action focus-workspace "$next"
