#!/usr/bin/env python3
"""
Watches all keyboard devices for Alt key release.
On release, if an Alt+Tab cycling session is active, immediately commits
the current workspace as MRU head and clears the session file.
"""
import asyncio
import glob
import os
import subprocess

from evdev import InputDevice, ecodes

STATE_FILE = "/tmp/niri-workspace-mru"
SESSION_FILE = "/tmp/niri-altab-session"
MAX_HISTORY = 20

ALT_KEYS = {ecodes.KEY_LEFTALT, ecodes.KEY_RIGHTALT}


def get_keyboards():
    devices = []
    for path in glob.glob("/dev/input/event*"):
        try:
            dev = InputDevice(path)
            caps = dev.capabilities()
            if ecodes.EV_KEY in caps and ecodes.KEY_LEFTALT in caps[ecodes.EV_KEY]:
                devices.append(dev)
        except Exception:
            pass
    return devices


def current_workspace():
    result = subprocess.run(
        ["niri", "msg", "workspaces"], capture_output=True, text=True
    )
    for line in result.stdout.splitlines():
        if "*" not in line:
            continue
        cleaned = line.replace("*", "").strip()
        parts = cleaned.split()
        if len(parts) >= 2:
            return parts[1].strip('"')
        if len(parts) == 1 and parts[0].isdigit():
            return parts[0]
    return None


def commit_session():
    if not os.path.exists(SESSION_FILE):
        return
    ws = current_workspace()
    if not ws:
        os.remove(SESSION_FILE)
        return
    try:
        with open(STATE_FILE) as f:
            history = [x.strip() for x in f if x.strip()]
    except FileNotFoundError:
        history = []
    history = [ws] + [x for x in history if x != ws]
    with open(STATE_FILE, "w") as f:
        f.write("\n".join(history[:MAX_HISTORY]) + "\n")
    os.remove(SESSION_FILE)


async def watch(dev):
    async for event in dev.async_read_loop():
        if (
            event.type == ecodes.EV_KEY
            and event.code in ALT_KEYS
            and event.value == 0  # key release
        ):
            commit_session()


async def main():
    keyboards = get_keyboards()
    if not keyboards:
        raise RuntimeError("No keyboard devices accessible — check input group membership")
    print(f"Watching {len(keyboards)} device(s): {[d.name for d in keyboards]}")
    await asyncio.gather(*[watch(kb) for kb in keyboards])


asyncio.run(main())
