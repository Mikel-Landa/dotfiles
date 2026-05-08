#!/bin/bash
# Statusline: model | ctx% ctx sesM ses | 5h% h:mm refresh
# ctx% / 5h% / refresh sourced from Claude Code statusline JSON.
# session tokens = cumulative usage (input + output + cache create + cache read)
# summed from current transcript file.

INPUT=$(cat)
exec python3 - "$INPUT" <<'PY'
import json, os, sys, time

raw = sys.argv[1] if len(sys.argv) > 1 else sys.stdin.read()
try:
    inp = json.loads(raw)
except Exception:
    inp = {}

model = (inp.get("model") or {}).get("display_name") or "Claude"

ctx = inp.get("context_window") or {}
ctx_pct = int(ctx.get("used_percentage") or 0)

rl = (inp.get("rate_limits") or {}).get("five_hour") or {}
rl_pct = int(rl.get("used_percentage") or 0)
resets_at = rl.get("resets_at")
if resets_at:
    rem = max(0, int(resets_at) - int(time.time()))
    h, m = divmod(rem // 60, 60)
    refresh = f"{h}:{m:02d}"
else:
    refresh = "--:--"

transcript = inp.get("transcript_path") or ""
session_total = 0
if transcript and os.path.exists(transcript):
    try:
        with open(transcript, "r", errors="replace") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    o = json.loads(line)
                except Exception:
                    continue
                u = ((o.get("message") or {}).get("usage")) or {}
                session_total += (
                    (u.get("input_tokens") or 0)
                    + (u.get("output_tokens") or 0)
                    + (u.get("cache_creation_input_tokens") or 0)
                    + (u.get("cache_read_input_tokens") or 0)
                )
    except OSError:
        pass

print(f"{model} | {ctx_pct}% ctx {session_total/1_000_000:.1f}M ses | {rl_pct}% {refresh} refresh")
PY
