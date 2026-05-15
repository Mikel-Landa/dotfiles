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
    now = int(time.time())
    rem = max(0, int(resets_at) - now)
    h, m = divmod(rem // 60, 60)
    import datetime
    reset_local = datetime.datetime.fromtimestamp(int(resets_at))
    reset_clock = f"{reset_local.hour}:{reset_local.minute:02d}"
    refresh = f"{reset_clock} ({h}:{m:02d})"
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

def compact_path(raw):
    if not raw:
        return ""
    home = os.path.expanduser("~")
    if raw == home:
        return "~"
    if raw.startswith(home + "/"):
        full = "~/" + raw[len(home) + 1:]
        parts = full.split("/")
    else:
        parts = raw.lstrip("/").split("/")
        parts = ["/" + parts[0]] + parts[1:] if parts else ["/"]
    if len(parts) <= 3:
        return "/".join(parts).replace("//", "/")
    return ".../" + "/".join(parts[-3:])

cwd_raw = inp.get("cwd") or ""
path_str = compact_path(cwd_raw)

left = f"{model} | {ctx_pct}% ctx {session_total/1_000_000:.1f}M ses | {rl_pct}% {refresh} refresh"

import shutil, subprocess
def detect_cols():
    if os.environ.get("TMUX"):
        try:
            out = subprocess.run(
                ["tmux", "display-message", "-p", "#{pane_width}"],
                capture_output=True, text=True, timeout=0.5,
            )
            n = int(out.stdout.strip())
            if n > 0:
                return n
        except Exception:
            pass
    if os.environ.get("KITTY_LISTEN_ON"):
        try:
            out = subprocess.run(
                ["kitten", "@", "ls", "--match", "state:focused"],
                capture_output=True, text=True, timeout=0.5,
            )
            data = json.loads(out.stdout)
            for w in data:
                for t in w.get("tabs", []):
                    for win in t.get("windows", []):
                        if win.get("is_focused"):
                            n = int(win.get("columns") or 0)
                            if n > 0:
                                return n
        except Exception:
            pass
    try:
        c = int(os.environ.get("COLUMNS") or 0)
        if c > 0:
            return c
    except ValueError:
        pass
    return shutil.get_terminal_size(fallback=(80, 24)).columns

cols = detect_cols()

RIGHT_MARGIN = 3
if path_str:
    pad = max(1, cols - len(left) - len(path_str) - RIGHT_MARGIN)
    print(left + (" " * pad) + path_str)
else:
    print(left)
PY
