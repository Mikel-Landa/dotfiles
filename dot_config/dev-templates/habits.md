# Supply-chain habits
1. Don't blind-update. No `npm/pnpm update --latest` across everything. Justify each bump.
2. Fewer deps. Prefer a snippet over lodash; `fetch` over axios; let AI write small helpers.
3. Pin exact versions in package.json (global save-exact handles `add`). Transitive deps still use ranges -> that's why the cooldown matters.
4. Always commit lockfiles. Never .gitignore them.
5. Clean installs in CI/prod (`pnpm install --frozen-lockfile`, `npm ci`).
6. Watch LLM/agent installs — they may bypass cooldown with `--latest`.
