#!/usr/bin/env python3
"""
Tracks workspace focus order for MRU-based Alt+Tab cycling.
Writes history to /tmp/niri-workspace-mru (most recent first, one ref per line).
Pauses recording while an Alt+Tab session is active (session file is fresh).
"""
import subprocess
import re
import os

STATE_FILE = "/tmp/niri-workspace-mru"
SESSION_FILE = "/tmp/niri-altab-session"
MAX_HISTORY = 20

PATTERN = re.compile(
    r'Workspace \{ id: \d+, idx: (\d+), name: (Some\("([^"]+)"\)|None)[^}]*is_focused: true'
)

def parse_focused(line):
    if not line.startswith("Workspaces changed:"):
        return None
    m = PATTERN.search(line)
    if not m:
        return None
    idx = int(m.group(1))
    name = m.group(3)
    return name if name else str(idx)

def is_session_active():
    return os.path.exists(SESSION_FILE)

def read_history():
    try:
        with open(STATE_FILE) as f:
            return [x.strip() for x in f if x.strip()]
    except FileNotFoundError:
        return []

def write_history(history):
    with open(STATE_FILE, "w") as f:
        f.write("\n".join(history[:MAX_HISTORY]) + "\n")

def update(ref):
    if is_session_active():
        return
    history = [x for x in read_history() if x != ref]
    write_history([ref] + history)

def seed_named_workspaces():
    """Pre-populate MRU with named workspaces so first Alt+Tab has something to work with."""
    result = subprocess.run(["niri", "msg", "workspaces"], capture_output=True, text=True)
    named = []
    for line in result.stdout.splitlines():
        stripped = line.replace("*", "").strip()
        parts = stripped.split()
        if len(parts) >= 2 and parts[0].isdigit():
            named.append(parts[1].strip('"'))
    if named:
        history = read_history()
        for ws in reversed(named):
            if ws not in history:
                history = [ws] + history
        write_history(history)

seed_named_workspaces()

proc = subprocess.Popen(
    ["niri", "msg", "event-stream"],
    stdout=subprocess.PIPE,
    stderr=subprocess.DEVNULL,
    text=True,
)

for line in proc.stdout:
    ref = parse_focused(line.strip())
    if ref:
        update(ref)
