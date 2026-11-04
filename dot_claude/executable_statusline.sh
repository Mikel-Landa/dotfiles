#!/bin/bash
# Claude Code status line: model | context % | 7d usage window % + pace
#
# pace = (usage spent) / (time elapsed) as fractions of the 7-day window,
# i.e. burn rate. 1.00x = exactly on pace, >1 = burning too fast, <1 = spare.
#
# Claude Code pipes a JSON blob on stdin. The rate_limits object is only present
# for claude.ai Pro/Max subscriptions and only after the first API response, and
# each window can be absent on its own, so every segment below is optional.
#
# Test with:
#   echo '{"model":{"display_name":"Opus"},"context_window":{"used_percentage":25},
#          "rate_limits":{"seven_day":{"used_percentage":40,"resets_at":1738425600}}}' \
#     | ~/.claude/statusline.sh

input=$(cat)

RED=$'\033[31m'
YELLOW=$'\033[33m'
GREEN=$'\033[32m'
DIM=$'\033[2m'
RESET=$'\033[0m'

# One jq call; each line is a field, "" when absent. Rounding happens in jq so
# the script does not depend on the shell locale's decimal separator.
mapfile -t F < <(printf '%s' "$input" | jq -r '
  def pct: if . == null then "" else round end;
  def epoch: if . == null then "" else floor end;
  (.model.display_name // "Claude"),
  (.context_window.used_percentage // null | pct),
  (.rate_limits.seven_day.used_percentage // null | pct),
  (.rate_limits.seven_day.resets_at // null | epoch),
  (.rate_limits.seven_day as $w
   | if $w.used_percentage == null or $w.resets_at == null then ""
     # elapsed floored at 1h so the first minutes of a window do not show 500x
     else ($w.used_percentage / 100)
          / ([604800 - ($w.resets_at - now), 3600] | max / 604800)
          | . * 100 | round end),  # pace in hundredths
  (.rate_limits.seven_day as $w
   | if ($w.used_percentage // 0) <= 0 or $w.resets_at == null then ""
     # at the current burn rate, when usage hits 100%; "" if not before reset
     else (now + ([604800 - ($w.resets_at - now), 3600] | max)
                 * (100 - $w.used_percentage) / $w.used_percentage)
          | if . < $w.resets_at then floor else "" end end)
' 2>/dev/null)

MODEL=${F[0]:-Claude}
CTX=${F[1]}
WEEK=${F[2]}
WEEK_RESET=${F[3]}
P100=${F[4]}
HIT=${F[5]}

# Green under 70%, yellow 70-89%, red 90%+.
color_for() {
  if   [ "$1" -ge 90 ]; then printf '%s' "$RED"
  elif [ "$1" -ge 70 ]; then printf '%s' "$YELLOW"
  else                       printf '%s' "$GREEN"
  fi
}

# Human-readable time until an epoch-seconds timestamp: 2d3h, 4h07m, 35m.
until_reset() {
  local left h m
  left=$(( $1 - $(date +%s) ))
  [ "$left" -lt 0 ] && left=0
  h=$(( left / 3600 ))
  m=$(( (left % 3600) / 60 ))
  if   [ "$h" -ge 24 ]; then printf '%dd%dh' $(( h / 24 )) $(( h % 24 ))
  elif [ "$h" -gt 0 ];  then printf '%dh%02dm' "$h" "$m"
  else                       printf '%dm' "$m"
  fi
}

# A usage-window segment: "5h 23% ↻4h07m" with the % colour-coded.
window() { # label pct resets_at
  local seg="$1 $(color_for "$2")$2%${RESET}"
  [ -n "$3" ] && seg+=" ${DIM}↻$(until_reset "$3")${RESET}"
  printf '%s' "$seg"
}

LINE="[$MODEL]"
[ -n "$CTX" ]    && LINE+=" | ctx $(color_for "$CTX")${CTX}%${RESET}"
[ -n "$WEEK" ]   && LINE+=" | $(window 7d "$WEEK" "$WEEK_RESET")"
if [ -n "$P100" ]; then
  # Green <= 1x, yellow 1-1.25x, red above.
  if   [ "$P100" -le 100 ]; then PC=$GREEN
  elif [ "$P100" -le 125 ]; then PC=$YELLOW
  else                           PC=$RED
  fi
  LINE+=" pace ${PC}$(( P100 / 100 )).$(printf %02d $(( P100 % 100 )))x${RESET}"
  [ -n "$HIT" ] && LINE+=" ${PC}$(date -d "@$HIT" +%a)${RESET}"
fi

printf '%s\n' "$LINE"
