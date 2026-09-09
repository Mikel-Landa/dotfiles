"""Run with python3; requires chezmoi, mise, and network access."""

import json
import os
from pathlib import Path
import subprocess
import tempfile


with tempfile.TemporaryDirectory(prefix="chezmoi-bootstrap-") as temporary:
    root = Path(temporary)
    home = root / "home with spaces"
    home.mkdir()
    config = root / "config.json"
    config.write_text(json.dumps({"data": {
        "work": False, "isWsl": False, "winUser": "",
        "email": "test@example.invalid", "realName": "Bootstrap Test",
    }}))
    environment = dict(os.environ, HOME=str(home),
                       XDG_CONFIG_HOME=str(home / ".config"),
                       XDG_CACHE_HOME=str(home / ".cache"),
                       XDG_DATA_HOME=str(home / ".local/share"),
                       XDG_STATE_HOME=str(home / ".local/state"),
                       MISE_CONFIG_DIR=str(home / ".config/mise"),
                       MISE_DATA_DIR=str(home / ".local/share/mise"))
    command = ["chezmoi", "--source", str(Path(__file__).resolve().parents[1]),
               "--destination", str(home), "--config", str(config),
               "--persistent-state", str(root / "state.boltdb"), "--force"]

    def run(*arguments):
        result = subprocess.run(command + list(arguments), cwd=home,
                                env=environment, capture_output=True,
                                text=True, timeout=300)
        if result.returncode:
            raise RuntimeError(result.stdout + result.stderr)
        return result.stdout

    settings = home / ".claude/settings.json"
    expected = json.loads(run("cat", str(settings)))
    targets = [str(home / ".chezmoiscripts/40-claude-runtime.sh"),
               str(home / ".claude"), str(home / ".agents")]
    run("apply", *targets)
    assert (home / ".claude/gsd-core/VERSION").read_text().strip() == "1.7.0"
    assert json.loads(settings.read_text()) == expected, "Installer overwrote managed Claude settings"
    run("apply", *targets)
    assert json.loads(settings.read_text()) == expected, "Reapply changed managed Claude settings"
    print("PASS: real bootstrap/apply and reapply preserve managed Claude settings")
