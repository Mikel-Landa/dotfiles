# Supply-Chain Hardening — Design Spec

- **Date:** 2026-05-31
- **Status:** EXECUTED on feature branches (not merged). chezmoi `security/supply-chain-hardening`, git-org/app `security/pnpm11-cooldown`, projects `security/supply-chain-hardening`. Phase 4 (Rust) = verified already-hardened, no changes. All globals live-verified.

## Verified during design (de-risked)

- **pnpm global config linchpin — CONFIRMED.** Temp `XDG_CONFIG_HOME` + `pnpm/config.yaml` → `pnpm config get minimumReleaseAge` returns `1440` and `blockExoticSubdeps` returns `true`. pnpm reads these from the global `~/.config/pnpm/config.yaml`, so the "global → all future projects" promise (Layer 1) holds.
- **npm keys recognized & active.** Machine runs **npm 11.12.1** (≥ 11.10 floor). All four keys are defined in `@npmcli/config` `definitions.js` (`allow-git` L190, `min-release-age` L1362, plus `ignore-scripts`/`save-exact`). **Verification gotcha:** `min-release-age` is *exclusive with* `before` and npm normalizes it into a `before` date — so `npm config get min-release-age` returns `null` even when set. Verify via `npm config ls -l`, which shows the **derived** `before` ≈ now−(min-release-age days) plus the applied `allow-git="none"`, `ignore-scripts=true`, `save-exact=true`. Confirmed live: `before = 2026-05-30T…` (~24h ago) with `min-release-age=1`.
- **Source:** Better Stack, *"npm installs can hack your laptop (Here's how to stop it)"* (`Wq6yMdt11LM`, pub 2026-05-31). Cited resource: `github.com/lirantal/npm-security-best-practices`. Tool: Socket Firewall Free.

## Context

npm supply-chain attacks (Shai-Hulud / Mini Shai-Hulud, the chalk/debug and TanStack compromises) now land roughly weekly. The dominant vector is a malicious *new* package version executing a lifecycle (postinstall) script the moment it installs, stealing developer/CI secrets. The video distills 7 cheap mitigations across npm/pnpm/bun. This spec applies them to the user's machine and repos, **global-first** (so all future projects inherit them), and extends the JS tooling to Rust/Python where it reaches.

## Goals

- Harden the machine and **every future project** with minimal per-repo work (global config via chezmoi).
- Cover all 7 video mitigations.
- Enforce the controls in CI for the repos that actually ship (global config does not reach CI runners or collaborators).
- Extend install-time scanning to Rust and Python via Socket Firewall.

## Non-goals (explicitly out)

GitHub Actions SHA-pinning, `cargo-vet`, SLSA/provenance attestation, signed commits, Socket paid tiers. Not in the video; revisit later.

## Locked decisions

- Package manager: **pnpm 11** (machine already runs 11.1.2; cooldown needs ≥10.16).
- `projects/` npm→pnpm: **fresh `pnpm install`** (pull latest, cooled-down versions — not `pnpm import`).
- **No bun** (no bun repos) — bun globals skipped.
- **Socket Firewall only** for scanning (npq skipped).
- **Belt-and-suspenders**: shipping repos (`git-org/app`, `projects/`) pin the controls in-repo *and* inherit them globally — in-repo is required for CI/collaborators.
- Cooldown value: **1 day** (pnpm 1440 min; npm 1 day).

## Current state (surveyed)

- `~/repos/projects` (`tools-core`): plain **npm**, `package-lock.json`, no `.npmrc`, GitHub Actions `deploy.yml` (`npm ci`).
- `~/repos/git-org/app` (`@granite-web/root`): **pnpm**, pinned `pnpm@10.3.0` (too old — corepack forces it, bypassing global 11), `preinstall: only-allow pnpm`, no `.npmrc`, no in-repo cooldown, no `onlyBuiltDependencies`. CI is the in-house `ci/` system, no GitHub workflow.
- `~/repos/git-org` Rust: **separate git repos** (server, forge, ci, granite-*) per the umbrella `Cargo.toml`; already strong cargo-deny (schema 0.19.x, daily advisory surveillance, documented ignores w/ expiry, `deny-freshness-check.sh`).
- **No Python or Go repos** under `~/repos`.
- chezmoi source: `~/.local/share/chezmoi`; `dot_config/*` → `~/.config/*`; **metapac** is the package source-of-truth (`cargo`/`go`/`uv`/`npm` backends). `~/.cargo/config.toml` exists (sccache) but is **not** chezmoi-managed.

## Architecture — two layers

- **Layer 1 — Global (chezmoi):** hardens this machine + all future local projects. The new core.
- **Layer 2 — Per-repo:** the bits global cannot reach — `packageManager` pin, lockfile migration, in-repo cooldown for CI, Rust `deny.toml`.

CI runners and collaborators have no chezmoi home, so Layer 2 is mandatory for shipping repos, not optional.

## The 7 mitigations → mapping

| # | Mitigation | Global (chezmoi) | Per-repo (CI/ship) |
|---|---|---|---|
| 1 | Release-age cooldown | pnpm `config.yaml` `minimumReleaseAge: 1440`; npm `.npmrc` `min-release-age=1` | app + projects `pnpm-workspace.yaml` pin same |
| 2 | Disable install scripts | npm `.npmrc` `ignore-scripts=true` (pnpm/bun off by default) | app `onlyBuiltDependencies` allowlist (`pnpm approve-builds`) |
| 3 | Block git deps | pnpm `blockExoticSubdeps: true`; npm `allow-git=none` (npm ≥11.10) | mirror in repo configs |
| 3+ | pnpm trust policy (no-downgrade) | pnpm `config.yaml` (exact key — verify) | mirror in repo |
| 4 | Scan before install | `sfw` global + zsh aliases over pnpm/npm/cargo/uv/pip | `socketdev/action@v1` + `sfw pnpm install --frozen-lockfile` in `deploy.yml` |
| 5 | Lockfile injection | — | pnpm not vulnerable; `lockfile-lint` only for any remaining npm/yarn/bun repo |
| 6 | Clean install | pnpm auto-frozen in CI | projects `deploy.yml` → `pnpm install --frozen-lockfile`; commit lockfiles |
| 7 | Habits | global `save-exact=true` (npm + pnpm) | checklist doc; fewer deps; justify upgrades; no blind `update` |

**Cross-ecosystem:** Socket Firewall (`sfw`, `npm i -g sfw`) wraps `cargo`, `uv`, `pip` as well as JS — one global tool + aliases extends scanning to **Rust and Python**. Go is **not** in the free tier → use `govulncheck` + `go.sum`.

## Layer 1 — chezmoi files (new/edited)

1. `dot_npmrc` → `~/.npmrc`:
   ```
   ignore-scripts=true
   allow-git=none
   min-release-age=1
   save-exact=true
   ```
2. `dot_config/pnpm/config.yaml` → `~/.config/pnpm/config.yaml`:
   ```yaml
   minimumReleaseAge: 1440
   minimumReleaseAgeExclude: []   # "pkg@ver" entries with justification, for hotfixes
   blockExoticSubdeps: true
   savePrefix: ''                 # exact pins
   # trust policy: no-downgrade — exact key TBV during implementation
   ```
3. `dot_config/go/env` → `~/.config/go/env`:
   ```
   GOFLAGS=-mod=readonly
   GOPROXY=https://proxy.golang.org,direct
   GOSUMDB=sum.golang.org
   ```
4. `dot_config/uv/uv.toml` → safe locking defaults (no native cooldown — documented).
5. zsh aliases for `sfw` over npm/pnpm/cargo/uv/pip (in the existing zsh config; placement TBD during impl).
6. `dot_config/dev-templates/` → `rust-deny.toml`, `lockfile-lint` snippet, `python-checklist.md`, `go-checklist.md` (starter templates copied into new repos).
7. **metapac** `groups/terminal.toml` (per `dot_config/metapac/AGENTS.md` — edit in chezmoi, portable backends): `sfw`, `cargo-deny`, `cargo-audit` (cargo); `govulncheck`, `osv-scanner` (go); `pip-audit` (uv).

## Layer 2 — per-repo

- **`git-org/app`**: bump `packageManager` → `pnpm@11.x` (exact); add cooldown + `blockExoticSubdeps` + trust policy to `pnpm-workspace.yaml`; capture `onlyBuiltDependencies` via `pnpm approve-builds`; **verify `pnpm install` + `pnpm gate` pass**.
- **`projects/`**: add `packageManager: pnpm@11.x` + `preinstall: only-allow pnpm`; **fresh `pnpm install`**, delete `package-lock.json`; add `pnpm-workspace.yaml` with the cooldown block; update `deploy.yml` (corepack, cache→pnpm, `npm ci`→`pnpm install --frozen-lockfile`, add `socketdev/action@v1`).
- **Rust repos**: inventory `deny.toml` across all `git-org` Rust repos; fill gaps in house style; confirm cargo-deny runs in CI; optional `sfw cargo` wrap. No cargo-audit duplication beyond install. Document the no-cooldown asymmetry.

## Honest asymmetry & caveats

- Literal 1-day wait = pnpm/npm only. Rust/Go/Python equivalent = lockfile pinning + checksum/proxy + vuln scanning + Socket + deliberate manual updates.
- `npx`/`bunx` ignore cooldown. LLMs may bypass with `--latest` — watch agentic installs.
- Global `ignore-scripts=true` can break a global `npm i -g` of a tool that needs to build — use `--ignore-scripts=false` deliberately when needed.
- Socket Firewall Free = wrapper mode, no Go.
- npm `min-release-age` / `allow-git` need npm CLI ≥ 11.10 (machine has 11.12.1 ✓).
- After installing `sfw`, clear the package-manager cache so existing packages get re-checked.
- **`sfw` shell alias covers interactive shells only** — scripts, git hooks, and CI that call `pnpm`/`cargo` directly are NOT wrapped. So the alias is ad-hoc dev-machine coverage; CI coverage comes from `socketdev/action@v1`.

## Open questions to verify during implementation

1. pnpm **trust-policy** exact key/value in `config.yaml` (the "no-downgrade" bonus mitigation — key name unconfirmed).
2. zsh alias placement (`dot_zshrc` vs `dot_config/zsh/`) and interaction with existing aliases.
3. `~/.cargo/config.toml` is unmanaged — decide whether to bring under chezmoi or leave (low supply-chain value; cargo has no global cooldown/deny).
4. Confirm `min-release-age` is actually *applied* at npm resolution (not just recognized) — a scratch install check.

## Sequencing

1. **Layer 1 globals** (chezmoi: npm/pnpm/go/uv configs + metapac tools + sfw aliases) → `chezmoi apply`, verify honoring.
2. **`git-org/app`** (pnpm 11 bump + in-repo hardening + gate verify).
3. **`projects/`** (npm→pnpm fresh + deploy.yml).
4. **Rust** (deny.toml verify/fill).
5. **Templates + checklist** (`dev-templates/`, habits doc).

## Verification

- `chezmoi apply` clean; `pnpm config get` reflects globals; a test install in a scratch dir is cooled-down.
- `git-org/app`: `pnpm gate` green after bump.
- `projects/`: `pnpm install --frozen-lockfile` + build/test green; `deploy.yml` runs with `sfw` + frozen install.
- Rust: `cargo deny check` green across repos.
- `sfw pnpm add <test>` blocks/permits as expected.
