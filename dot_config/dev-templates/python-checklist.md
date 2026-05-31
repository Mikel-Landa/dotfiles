# Python supply-chain checklist (new repos)
- Use `uv`; commit `uv.lock`; install with `uv sync --locked` (or `--frozen` in CI).
- `sfw uv pip install ...` for install-time scanning (Socket supports uv/pip).
- `pip-audit` in CI.
- Hash-pin (`--require-hashes`) once the lock is stable.
- No native cooldown — rely on lockfile pinning + Socket + pip-audit.
