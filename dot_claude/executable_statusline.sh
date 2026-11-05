#!/bin/bash
# Claude Code status line:
#   model | context % | 7d usage % + pace | API spend limit % + pace
#
# pace = (usage spent) / (time elapsed) as fractions of the window, i.e. burn
# rate. 1.00x = exactly on pace, >1 = burning too fast, <1 = spare. After the
# pace comes the projected moment you hit 100% at that rate (omitted if not
# before the reset).
#
# Claude Code pipes a JSON blob on stdin. rate_limits is only present after the
# first API response, and only for claude.ai subscriptions (five_hour /
# seven_day) or behind a Claude gateway that sets a spend limit (spend_limit).
# Every window can be absent on its own, so every segment below is optional.
#
# Enterprise usage-based seats get rate_limits: null, so when that happens the
# monthly spend limit is fetched from /api/oauth/usage (extra_usage, the same
# source as /usage) with the OAuth token in ~/.claude/.credentials.json, cached
# in ~/.cache/claude-statusline/ and refreshed in the background every 5 min.
# Its reset is assumed to be the 1st of next month (UTC).
#
# Test with:
#   echo '{"model":{"display_name":"Opus"},"context_window":{"used_percentage":25},
#          "rate_limits":{"seven_day":{"used_percentage":40,"resets_at":1738425600},
#            "spend_limit":{"used_percentage":30,"resets_at":1738425600,
#              "used_usd":60,"limit_usd":200,"period":"monthly"}}}' \
#     | ~/.claude/statusline.sh

input=$(cat)

CACHE_DIR="$HOME/.cache/claude-statusline"
USAGE="$CACHE_DIR/usage.json"
STAMP="$CACHE_DIR/usage.stamp"   # last fetch attempt, so failures do not retry every render
CREDS="$HOME/.claude/.credentials.json"

# Refresh the usage cache in the background when Claude Code gave no limits.
if printf '%s' "$input" | jq -e '.rate_limits == null' >/dev/null 2>&1 \
   && [ -r "$CREDS" ]; then
  mkdir -p "$CACHE_DIR"
  if [ ! -f "$STAMP" ] || [ $(( $(date +%s) - $(stat -c %Y "$STAMP") )) -ge 300 ]; then
    touch "$STAMP"
    (
      tok=$(jq -r '.claudeAiOauth.accessToken // empty' "$CREDS")
      [ -n "$tok" ] || exit 0
      tmp=$(mktemp "$CACHE_DIR/usage.XXXXXX")
      if curl -sf -m 10 https://api.anthropic.com/api/oauth/usage \
           -H "Authorization: Bearer $tok" -H "anthropic-beta: oauth-2025-04-20" \
           -o "$tmp" && jq -e '.extra_usage' "$tmp" >/dev/null 2>&1; then
        mv "$tmp" "$USAGE"
      else
        rm -f "$tmp"
      fi
    ) </dev/null >/dev/null 2>&1 &
  fi
fi
[ -s "$USAGE" ] || USAGE=/dev/null

RED=$'\033[31m'
YELLOW=$'\033[33m'
GREEN=$'\033[32m'
DIM=$'\033[2m'
RESET=$'\033[0m'

# One jq call; each line is a field, "" when absent. Rounding happens in jq so
# the script does not depend on the shell locale's decimal separator.
mapfile -t F < <(printf '%s' "$input" | jq -r --slurpfile u "$USAGE" '
  # Fill spend_limit from the cached /api/oauth/usage extra_usage block.
  ($u[0].extra_usage // null) as $x
  | if .rate_limits == null and $x.is_enabled == true
       and $x.monthly_limit != null and $x.used_credits != null then
      (pow(10; $x.decimal_places // 2)) as $d
      | .rate_limits.spend_limit = {
          used_percentage: ($x.utilization // ($x.used_credits * 100 / $x.monthly_limit)),
          used_usd: ($x.used_credits / $d),
          limit_usd: ($x.monthly_limit / $d),
          period: "monthly",
          resets_at: (now | gmtime | .[1] += 1 | .[2] = 1
                      | .[3] = 0 | .[4] = 0 | .[5] = 0 | mktime)
        }
    else . end
  |

  def pct: if . == null then "" else round end;
  def epoch: if . == null then "" else floor end;
  def usd: if . == null then "" else round end;

  # Window length in seconds. Monthly = resets_at minus the same instant one
  # calendar month earlier (timegm normalises month -1 into last December).
  def winlen($w):
    if   $w.period == "daily"   then 86400
    elif $w.period == "weekly"  then 604800
    elif $w.period == "monthly" then
      ($w.resets_at | floor) - ($w.resets_at | floor | gmtime | .[1] -= 1 | mktime)
    else null end;

  # Elapsed time in the window, floored at 1h so the first minutes do not show 500x.
  def elapsed($w; $len): [$len - ($w.resets_at - now), 3600] | max;

  # Emits 4 lines: used %, resets_at, pace in hundredths, projected 100% epoch.
  def stats($w; $len):
    ($w.used_percentage // null | pct),
    ($w.resets_at // null | epoch),
    (if $w.used_percentage == null or $w.resets_at == null or $len == null then ""
     else ($w.used_percentage / 100) / (elapsed($w; $len) / $len)
          | . * 100 | round end),
    (if ($w.used_percentage // 0) <= 0 or $w.resets_at == null or $len == null then ""
     elif $w.used_percentage >= 100 then ""
     else (now + elapsed($w; $len) * (100 - $w.used_percentage) / $w.used_percentage)
          | if . < $w.resets_at then floor else "" end end);

  (.model.display_name // "Claude"),
  (.context_window.used_percentage // null | pct),
  (.rate_limits.seven_day // {} | stats(.; 604800)),
  (.rate_limits.spend_limit // {} | stats(.; winlen(.))),
  (.rate_limits.spend_limit.used_usd // null | usd),
  (.rate_limits.spend_limit.limit_usd // null | usd),
  (.rate_limits.spend_limit.period // ""),
  (.effort.level // "")
' 2>/dev/null)

MODEL=${F[0]:-Claude}
EFFORT=${F[13]}
CTX=${F[1]}
WEEK=${F[2]};  WEEK_RESET=${F[3]};  WEEK_P100=${F[4]};  WEEK_HIT=${F[5]}
SPEND=${F[6]}; SPEND_RESET=${F[7]}; SPEND_P100=${F[8]}; SPEND_HIT=${F[9]}
SPEND_USD=${F[10]}; LIMIT_USD=${F[11]}; PERIOD=${F[12]}

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

# A usage-window segment: "7d 23% ↻4h07m" with the % colour-coded.
window() { # label pct resets_at [extra]
  local seg="${1:+$1 }$(color_for "$2")$2%${RESET}"
  [ -n "$4" ] && seg+=" $4"
  [ -n "$3" ] && seg+=" ↻$(until_reset "$3")"
  printf '%s' "$seg"
}

# " pace 1.10x Thu": burn rate plus when 100% is hit (date fmt per window size).
pace() { # p100 hit_epoch date_fmt
  [ -z "$1" ] && return
  local pc
  # Green <= 1x, yellow 1-1.25x, red above.
  if   [ "$1" -le 100 ]; then pc=$GREEN
  elif [ "$1" -le 125 ]; then pc=$YELLOW
  else                        pc=$RED
  fi
  printf ' pace %s%d.%02dx%s' "$pc" $(( $1 / 100 )) $(( $1 % 100 )) "$RESET"
  [ -n "$2" ] && printf ' %s%s%s' "$pc" "$(date -d "@$2" "+$3")" "$RESET"
}

LINE="[$MODEL]${EFFORT:+ $EFFORT}"
[ -n "$CTX" ] && LINE+=" | ctx $(color_for "$CTX")${CTX}%${RESET}"

if [ -n "$WEEK" ]; then
  LINE+=" | $(window 7d "$WEEK" "$WEEK_RESET")$(pace "$WEEK_P100" "$WEEK_HIT" '%a')"
fi

if [ -n "$SPEND" ]; then
  case "$PERIOD" in
    daily)   FMT='%H:%M' ;;
    weekly)  FMT='%a' ;;
    monthly) FMT='%b %-d' ;;
    *)       FMT='%b %-d' ;;
  esac
  DOLLARS=""
  [ -n "$SPEND_USD" ] && [ -n "$LIMIT_USD" ] && DOLLARS="\$${SPEND_USD}/\$${LIMIT_USD}"
  LINE+=" | $(window "" "$SPEND" "$SPEND_RESET" "$DOLLARS")$(pace "$SPEND_P100" "$SPEND_HIT" "$FMT")"
fi

printf '%s\n' "$LINE"
