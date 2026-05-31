# Supply-Chain Hardening Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Apply the 7 Better Stack supply-chain mitigations machine-wide (global, chezmoi-managed) plus in-repo for the shipping repos, extending install-time scanning to Rust/Python via Socket Firewall.

**Architecture:** Two layers. Layer 1 = global config in the chezmoi source repo (`~/.local/share/chezmoi`) → cascades to all current and future projects. Layer 2 = per-repo config for `git-org/app`, `projects/`, and the `git-org` Rust repos, required because CI runners and collaborators don't inherit the home config.

**Tech Stack:** pnpm 11, npm 11.12, chezmoi, metapac (cargo/go/uv/npm backends), Socket Firewall (`sfw`), cargo-deny, Go modules.

**Spec:** `docs/superpowers/specs/2026-05-31-supply-chain-hardening-design.md`

---

## Scope note

One unified plan, five phases. Each phase is independently testable/committable. Phases 2–4 (per-repo) could be split into separate plans if you prefer to execute them in different sessions — they only depend on Phase 1 being applied.

## Conventions (read once)

- **chezmoi edits happen in the SOURCE repo** `~/.local/share/chezmoi/`, never in `~/.config/*` directly (chezmoi apply overwrites). After editing source: `chezmoi apply`.
- `dot_<x>` in source → `~/.<x>`. `dot_config/<x>` → `~/.config/<x>`.
- The chezmoi repo has pre-commit hooks (`.pre-commit-config.yaml`) and a TOML formatter (`tombi`). If a commit is rejected by a hook, run the hook's fixer and re-stage.
- The four target repos are **separate git repos**: `~/.local/share/chezmoi`, `~/repos/projects`, `~/repos/git-org/app`, and each `~/repos/git-org/<rust-repo>`. Commit in the repo you're editing.

## File map

| File | Repo | Responsibility |
|---|---|---|
| `dot_npmrc` | chezmoi | npm global hardening |
| `dot_config/pnpm/config.yaml` | chezmoi | pnpm global hardening |
| `dot_config/go/env` | chezmoi | Go module global hardening |
| `dot_config/uv/uv.toml` | chezmoi | uv/Python global defaults |
| `dot_config/metapac/groups/terminal.toml` | chezmoi | install scanner tools |
| `dot_config/zsh/plugins/aliases.plugin.zsh` | chezmoi | `sfw` wrapper aliases |
| `dot_config/dev-templates/*` | chezmoi | starter templates + habits checklist |
| `package.json`, `pnpm-workspace.yaml` | git-org/app | pnpm 11 + in-repo cooldown |
| `package.json`, `pnpm-workspace.yaml`, `.github/workflows/deploy.yml` | projects | npm→pnpm + CI |
| `deny.toml` (gaps) | git-org rust repos | cargo-deny coverage |

---

## Phase 1 — Layer 1: global config (chezmoi)

### Task 1.1: npm global hardening (`~/.npmrc`)

**Files:**
- Create: `~/.local/share/chezmoi/dot_npmrc`

- [ ] **Step 1: Write the file**

```ini
# Supply-chain hardening — global npm defaults. See docs/superpowers/specs/2026-05-31-supply-chain-hardening-design.md
ignore-scripts=true
allow-git=none
min-release-age=1
save-exact=true
```

- [ ] **Step 2: Apply**

Run: `chezmoi apply ~/.npmrc`
Expected: no error; `~/.npmrc` now exists.

- [ ] **Step 3: Verify keys are honored**

Run: `npm config ls -l | grep -E '^(allow-git|before|ignore-scripts|save-exact) '`
Expected (user overrides): `allow-git = "none"`, `before = "<~24h ago ISO date>"`, `ignore-scripts = true`, `save-exact = true`.
NOTE: `min-release-age` is exclusive with `before` and npm normalizes it into a `before` date, so `npm config get min-release-age` returns `null` even when set — that is correct, not a bug. The cooldown is proven by the derived `before` value being ~1 day in the past.

- [ ] **Step 4: Commit (chezmoi repo)**

```bash
cd ~/.local/share/chezmoi
git add dot_npmrc
git commit -m "feat(security): global npm hardening (ignore-scripts, allow-git, min-release-age, save-exact)"
```

---

### Task 1.2: pnpm global hardening (`~/.config/pnpm/config.yaml`)

**Files:**
- Create: `~/.local/share/chezmoi/dot_config/pnpm/config.yaml`

- [ ] **Step 1: Write the file**

```yaml
# Supply-chain hardening — global pnpm defaults (verified: pnpm reads these from the global config.yaml).
minimumReleaseAge: 1440          # 1-day cooldown (minutes). pnpm 11 default; pinned explicitly.
minimumReleaseAgeExclude: []     # add "pkg@version" with a justification comment when a hotfix needs bypass
blockExoticSubdeps: true         # transitive deps may not use git/tarball sources
savePrefix: ''                   # exact version pins on `pnpm add`
```

- [ ] **Step 2: Apply**

Run: `chezmoi apply ~/.config/pnpm/config.yaml`
Expected: file exists at `~/.config/pnpm/config.yaml`.

- [ ] **Step 3: Verify honored**

Run: `pnpm config get minimumReleaseAge blockExoticSubdeps savePrefix`
Expected: `1440`, `true`, empty string (already verified during design that pnpm reads these globally).

- [ ] **Step 4: Commit**

```bash
cd ~/.local/share/chezmoi
git add dot_config/pnpm/config.yaml
git commit -m "feat(security): global pnpm cooldown + blockExoticSubdeps + exact pins"
```

---

### Task 1.3: Go module global hardening (`~/.config/go/env`)

**Files:**
- Create: `~/.local/share/chezmoi/dot_config/go/env`

- [ ] **Step 1: Write the file**

```ini
GOFLAGS=-mod=readonly
GOPROXY=https://proxy.golang.org,direct
GOSUMDB=sum.golang.org
```

- [ ] **Step 2: Apply**

Run: `chezmoi apply ~/.config/go/env`

- [ ] **Step 3: Verify**

Run: `go env GOFLAGS GOPROXY GOSUMDB`
Expected: `-mod=readonly`, `https://proxy.golang.org,direct`, `sum.golang.org`.

- [ ] **Step 4: Commit**

```bash
cd ~/.local/share/chezmoi
git add dot_config/go/env
git commit -m "feat(security): global Go module hardening (readonly, proxy, sumdb)"
```

---

### Task 1.4: uv/Python global defaults (`~/.config/uv/uv.toml`)

**Files:**
- Create: `~/.local/share/chezmoi/dot_config/uv/uv.toml`

- [ ] **Step 1: Write the file**

```toml
# Supply-chain hardening — global uv defaults.
# Note: uv has NO native release-age cooldown. Install-time scanning is provided by `sfw uv ...`
# (Socket Firewall) and `pip-audit` runs in CI. Lockfiles (uv.lock) + hashes are per-project.
[pip]
require-hashes = false   # set true per-project once a hash-pinned requirements lock exists
```

- [ ] **Step 2: Apply**

Run: `chezmoi apply ~/.config/uv/uv.toml`

- [ ] **Step 3: Verify**

Run: `test -f ~/.config/uv/uv.toml && echo OK`
Expected: `OK`. (No global uv setting to assert beyond file presence; uv has no cooldown.)

- [ ] **Step 4: Commit**

```bash
cd ~/.local/share/chezmoi
git add dot_config/uv/uv.toml
git commit -m "feat(security): global uv defaults + documented no-cooldown note"
```

---

### Task 1.5: install scanner tools via metapac

**Files:**
- Modify: `~/.local/share/chezmoi/dot_config/metapac/groups/terminal.toml`

- [ ] **Step 1: Add tools to the relevant backend sections**

In `terminal.toml`, add `"cargo-deny"` and `"cargo-audit"` to the existing `cargo.packages` array; add the two Go scanners to the existing `go.packages` array; and add new `npm` and `uv` sections. Resulting additions:

```toml
# inside cargo = { packages = [ ... ] }  — add:
    "cargo-deny",
    "cargo-audit",

# inside go = { packages = [ ... ] }  — add:
    "golang.org/x/vuln/cmd/govulncheck",
    "github.com/google/osv-scanner/v2/cmd/osv-scanner",

# new sections (append to file):
npm = {
  packages = [
    "sfw",
  ]
}

uv = {
  packages = [
    "pip-audit",
  ]
}
```

> If `go install github.com/google/osv-scanner/v2/cmd/osv-scanner@latest` fails on the module path, confirm the current path at github.com/google/osv-scanner and adjust; this is the only path that may have shifted.

- [ ] **Step 2: Apply + sync**

```bash
chezmoi apply ~/.config/metapac
metapac sync
```
Expected: metapac installs `sfw`, `cargo-deny`, `cargo-audit`, `govulncheck`, `osv-scanner`, `pip-audit`.

- [ ] **Step 3: Verify tools present**

Run: `command -v sfw cargo-deny cargo-audit govulncheck osv-scanner pip-audit`
Expected: a path printed for each.

- [ ] **Step 4: Commit**

```bash
cd ~/.local/share/chezmoi
git add dot_config/metapac/groups/terminal.toml
git commit -m "feat(security): add sfw + cargo-deny/audit + govulncheck/osv-scanner + pip-audit to metapac"
```

---

### Task 1.6: Socket Firewall wrapper aliases

**Files:**
- Modify: `~/.local/share/chezmoi/dot_config/zsh/plugins/aliases.plugin.zsh`

- [ ] **Step 1: Append the alias block**

```sh
# --- Socket Firewall (sfw) install-time scanning. Interactive shells only;
# --- CI coverage comes from socketdev/action. `command sfw` guard = no-op if sfw missing.
if (( $+commands[sfw] )); then
  alias pnpm='sfw pnpm'
  alias npm='sfw npm'
  alias cargo='sfw cargo'
  alias uv='sfw uv'
  alias pip='sfw pip'
fi
```

- [ ] **Step 2: Apply + reload**

```bash
chezmoi apply ~/.config/zsh/plugins/aliases.plugin.zsh
exec zsh
```

- [ ] **Step 3: Verify alias active**

Run: `alias pnpm`
Expected: `pnpm='sfw pnpm'`.

- [ ] **Step 4: Clear caches so existing packages get re-checked** (per Socket docs)

```bash
pnpm store prune || true
npm cache clean --force || true
```

- [ ] **Step 5: Commit**

```bash
cd ~/.local/share/chezmoi
git add dot_config/zsh/plugins/aliases.plugin.zsh
git commit -m "feat(security): sfw wrapper aliases for pnpm/npm/cargo/uv/pip"
```

---

### Task 1.7: project starter templates + habits checklist

**Files:**
- Create: `~/.local/share/chezmoi/dot_config/dev-templates/rust-deny.toml`
- Create: `~/.local/share/chezmoi/dot_config/dev-templates/lockfile-lint.md`
- Create: `~/.local/share/chezmoi/dot_config/dev-templates/python-checklist.md`
- Create: `~/.local/share/chezmoi/dot_config/dev-templates/go-checklist.md`
- Create: `~/.local/share/chezmoi/dot_config/dev-templates/habits.md`

- [ ] **Step 1: `rust-deny.toml`** (minimal starter for new Rust repos)

```toml
# Starter cargo-deny config for new Rust projects. Run: cargo deny check
[advisories]
version = 2
yanked = "deny"
unmaintained = "all"
ignore = []   # add "RUSTSEC-XXXX-YYYY" only with justification + expiry

[licenses]
version = 2
confidence-threshold = 0.93
allow = ["MIT", "Apache-2.0", "Apache-2.0 WITH LLVM-exception", "BSD-2-Clause", "BSD-3-Clause", "ISC", "Unicode-3.0"]

[bans]
multiple-versions = "warn"
wildcards = "deny"

[sources]
unknown-registry = "deny"
unknown-git = "deny"
allow-registry = ["https://github.com/rust-lang/crates.io-index"]
```

- [ ] **Step 2: `lockfile-lint.md`** (for any non-pnpm JS repo)

```markdown
# lockfile-lint (only needed for npm/yarn/bun repos — pnpm is not vulnerable to lockfile injection)

Install: `pnpm add -D lockfile-lint`  (or npm i -D)

CI check:
\`\`\`bash
npx lockfile-lint --path package-lock.json --type npm \
  --allowed-hosts npm --validate-https --validate-package-names
\`\`\`
Fails the build if a resolved URL points off-registry or a name/host mismatches.
```

- [ ] **Step 3: `python-checklist.md`**

```markdown
# Python supply-chain checklist (new repos)
- Use `uv`; commit `uv.lock`; install with `uv sync --locked` (or `--frozen` in CI).
- `sfw uv pip install ...` for install-time scanning (Socket supports uv/pip).
- `pip-audit` in CI.
- Hash-pin (`--require-hashes`) once the lock is stable.
- No native cooldown — rely on lockfile pinning + Socket + pip-audit.
```

- [ ] **Step 4: `go-checklist.md`**

```markdown
# Go supply-chain checklist (new repos)
- Globals already set via ~/.config/go/env (GOFLAGS=-mod=readonly, proxy, sumdb).
- Commit go.mod + go.sum.
- `govulncheck ./...` in CI.
- `osv-scanner -r .` for broader advisory coverage.
- Socket Firewall Free does NOT cover Go (Enterprise only) — govulncheck is the install-time check.
```

- [ ] **Step 5: `habits.md`** (mitigation #7)

```markdown
# Supply-chain habits
1. Don't blind-update. No `npm/pnpm update --latest` across everything. Justify each bump.
2. Fewer deps. Prefer a snippet over lodash; `fetch` over axios; let AI write small helpers.
3. Pin exact versions in package.json (global save-exact handles `add`). Transitive deps still use ranges → that's why the cooldown matters.
4. Always commit lockfiles. Never .gitignore them.
5. Clean installs in CI/prod (`pnpm install --frozen-lockfile`, `npm ci`).
6. Watch LLM/agent installs — they may bypass cooldown with `--latest`.
```

- [ ] **Step 6: Apply + verify**

```bash
chezmoi apply ~/.config/dev-templates
ls ~/.config/dev-templates
```
Expected: the 5 files listed.

- [ ] **Step 7: Commit**

```bash
cd ~/.local/share/chezmoi
git add dot_config/dev-templates
git commit -m "feat(security): dev-templates (rust-deny, lockfile-lint, py/go checklists, habits)"
```

---

## Phase 2 — git-org/app (pnpm 11 + in-repo hardening)

Repo: `~/repos/git-org/app`

### Task 2.1: bump packageManager to pnpm 11 and verify the gate

**Files:**
- Modify: `~/repos/git-org/app/package.json` (the `packageManager` field)

- [ ] **Step 1: Find the current latest pnpm 11 version**

Run: `pnpm --version`  → currently `11.1.2`. Use this exact version string in the pin (or a newer 11.x if installed).

- [ ] **Step 2: Edit the field**

In `~/repos/git-org/app/package.json` change:
```json
  "packageManager": "pnpm@10.3.0",
```
to (matching the version from Step 1):
```json
  "packageManager": "pnpm@11.1.2",
```

- [ ] **Step 3: Reinstall under pnpm 11**

```bash
cd ~/repos/git-org/app
corepack use pnpm@11.1.2 || true
pnpm install
```
Expected: install completes. pnpm may report packages with build scripts needing approval (e.g., esbuild).

- [ ] **Step 4: Approve required builds (if prompted)**

```bash
cd ~/repos/git-org/app
pnpm approve-builds
```
Select only the packages the build genuinely needs (e.g., esbuild). This writes `onlyBuiltDependencies` to `pnpm-workspace.yaml`.

- [ ] **Step 5: Verify the gate (quick gates first, then full)**

```bash
cd ~/repos/git-org/app
pnpm gate:lint && pnpm gate:typecheck
```
Expected: both pass. Then run the full gate:
```bash
pnpm gate
```
Expected: PASS. If a gate breaks due to the pnpm bump, fix before committing (do not weaken gates).

- [ ] **Step 6: Commit**

```bash
cd ~/repos/git-org/app
git add package.json pnpm-workspace.yaml pnpm-lock.yaml
git commit -m "chore(security): bump pnpm 10.3.0 -> 11.1.2; pin onlyBuiltDependencies"
```

---

### Task 2.2: in-repo supply-chain config (CI/collaborator enforcement)

**Files:**
- Modify: `~/repos/git-org/app/pnpm-workspace.yaml`

- [ ] **Step 1: Add the hardening block** to `pnpm-workspace.yaml` (keep the existing `packages:` and any `onlyBuiltDependencies` from Task 2.1):

```yaml
minimumReleaseAge: 1440
minimumReleaseAgeExclude: []
blockExoticSubdeps: true
savePrefix: ''
```

- [ ] **Step 2: Verify the repo resolves the settings**

```bash
cd ~/repos/git-org/app
pnpm config get minimumReleaseAge blockExoticSubdeps
```
Expected: `1440`, `true`.

- [ ] **Step 3: Verify a frozen install still works**

```bash
cd ~/repos/git-org/app
pnpm install --frozen-lockfile
```
Expected: PASS (lockfile already satisfies the cooldown for existing pinned versions).

- [ ] **Step 4: Commit**

```bash
cd ~/repos/git-org/app
git add pnpm-workspace.yaml
git commit -m "feat(security): in-repo pnpm cooldown + blockExoticSubdeps + exact pins"
```

---

## Phase 3 — projects/ (npm → pnpm, fresh)

Repo: `~/repos/projects`

### Task 3.1: convert to pnpm with a fresh install

**Files:**
- Modify: `~/repos/projects/package.json`
- Delete: `~/repos/projects/package-lock.json`
- Create: `~/repos/projects/pnpm-lock.yaml` (generated)

- [ ] **Step 1: Add packageManager + preinstall guard** to `package.json`:

```json
  "packageManager": "pnpm@11.1.2",
  "scripts": {
    "preinstall": "npx -y only-allow pnpm",
    "build": "node scripts/build.js",
    "test": "node scripts/run-tests.js"
  },
```
(Merge `preinstall` into the existing `scripts` object; keep `build`/`test`.)

- [ ] **Step 2: Fresh install (decision: latest cooled-down versions, not import)**

```bash
cd ~/repos/projects
rm -f package-lock.json
pnpm install
```
Expected: `pnpm-lock.yaml` created; `node_modules` populated with versions ≥1 day old (global cooldown applies).

- [ ] **Step 3: Verify build + test still pass**

```bash
cd ~/repos/projects
pnpm run build && pnpm run test
```
Expected: both succeed (same node scripts, now run via pnpm).

- [ ] **Step 4: Commit**

```bash
cd ~/repos/projects
git add package.json pnpm-lock.yaml
git rm --cached package-lock.json 2>/dev/null || true
git add -A
git commit -m "chore(security): migrate npm -> pnpm (fresh install), add only-allow guard"
```

---

### Task 3.2: in-repo cooldown config

**Files:**
- Create: `~/repos/projects/pnpm-workspace.yaml`

- [ ] **Step 1: Write the file**

```yaml
minimumReleaseAge: 1440
minimumReleaseAgeExclude: []
blockExoticSubdeps: true
savePrefix: ''
```

- [ ] **Step 2: Verify**

```bash
cd ~/repos/projects
pnpm config get minimumReleaseAge blockExoticSubdeps
```
Expected: `1440`, `true`.

- [ ] **Step 3: Commit**

```bash
cd ~/repos/projects
git add pnpm-workspace.yaml
git commit -m "feat(security): in-repo pnpm cooldown + blockExoticSubdeps"
```

---

### Task 3.3: update GitHub Actions deploy workflow

**Files:**
- Modify: `~/repos/projects/.github/workflows/deploy.yml`

- [ ] **Step 1: Update path triggers** — replace the two `package-lock.json` lines with `pnpm-lock.yaml` and add `pnpm-workspace.yaml`, in both the `push.paths` and `pull_request.paths` lists.

- [ ] **Step 2: Replace the setup-node + install steps.** Replace:

```yaml
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci
```
with:
```yaml
      - uses: pnpm/action-setup@v4

      - uses: actions/setup-node@v4
        with:
          node-version: '22'
          cache: 'pnpm'

      - name: Socket Firewall scan + install
        uses: socketdev/action@v1
        with:
          mode: firewall

      - name: Install dependencies
        run: pnpm install --frozen-lockfile
```

- [ ] **Step 3: Update build/test step commands** if they invoke node directly they are unchanged; if any used `npm run`, switch to `pnpm run`. (Current `deploy.yml` calls `node scripts/...` directly — no change needed there.)

- [ ] **Step 4: Lint the workflow YAML**

Run: `python3 -c "import yaml,sys; yaml.safe_load(open('.github/workflows/deploy.yml')); print('valid')"`
Expected: `valid`.

- [ ] **Step 5: Commit**

```bash
cd ~/repos/projects
git add .github/workflows/deploy.yml
git commit -m "ci(security): pnpm frozen-lockfile install + Socket Firewall scan in deploy"
```

---

## Phase 4 — Rust deny.toml coverage

Repos: each Rust repo under `~/repos/git-org` (server, forge, ci, granite-*, xtask, bench/*, e2e/*, tools/verdict, tests/saas-bench)

### Task 4.1: inventory and fill deny.toml gaps

**Files:**
- Create (where missing): `<rust-repo>/deny.toml`

- [ ] **Step 1: Inventory which crates already have deny.toml**

```bash
cd ~/repos/git-org
for d in $(find . -name Cargo.toml -not -path '*/target/*' | grep -v node_modules | xargs -n1 dirname | sort -u); do
  [ -f "$d/deny.toml" ] && echo "HAS  $d" || echo "MISS $d"
done
```
Expected: a HAS/MISS list. (Already confirmed: granite-auth/cli/gateway/placement, server, ci, forge, server-phase08 HAVE one.)

- [ ] **Step 2: For each MISS that is a real shippable crate** (skip throwaway bench/e2e fixtures unless desired), copy the starter and adjust the license `allow` list to match that repo's deps:

```bash
cp ~/.config/dev-templates/rust-deny.toml <missing-crate-dir>/deny.toml
```

- [ ] **Step 3: Verify cargo-deny passes per repo**

```bash
cd <rust-repo>
cargo deny check
```
Expected: `advisories ok`, `bans ok`, `licenses ok`, `sources ok`. Resolve any license gaps by adding the SPDX id to `allow` (with the same care as the existing house configs — never blanket-allow).

- [ ] **Step 4: Confirm cargo-deny runs in CI**

```bash
cd ~/repos/git-org
cat scripts/deny-freshness-check.sh
grep -rn "cargo deny\|cargo-deny" ci/ scripts/ 2>/dev/null | head
```
Expected: cargo-deny invocation found. If a newly-covered crate isn't wired into the CI loop, add it. Document where it runs.

- [ ] **Step 5: Commit (in each Rust repo that changed)**

```bash
cd <rust-repo>
git add deny.toml
git commit -m "feat(security): add cargo-deny coverage"
```

---

## Phase 5 — pnpm trust policy (bonus) + final verification

### Task 5.1: pnpm trust policy "no-downgrade" (bonus mitigation)

**Files:**
- Modify: `~/.local/share/chezmoi/dot_config/pnpm/config.yaml`

- [ ] **Step 1: Find the exact setting name.** The video calls it a "trust policy" set to "no downgrade" (install fails if a package's trust level dropped vs its previous release). Confirm the exact key/value at https://pnpm.io/settings (search "trust"). 

- [ ] **Step 2: Add it** to the global `config.yaml` (and mirror into the two repos' `pnpm-workspace.yaml`). Example shape (replace with the confirmed key):

```yaml
# <confirmed-key>: no-downgrade
```

- [ ] **Step 3: Verify**

```bash
pnpm config get <confirmed-key>
```
Expected: the set value. If pnpm 11.1.2 doesn't support it, note that and skip (non-blocking bonus).

- [ ] **Step 4: Commit**

```bash
cd ~/.local/share/chezmoi
git add dot_config/pnpm/config.yaml
git commit -m "feat(security): pnpm trust policy no-downgrade"
```

### Task 5.2: end-to-end verification

- [ ] **Step 1: Cooldown blocks a brand-new version** — in a scratch dir:

```bash
cd "$(mktemp -d)"; pnpm init >/dev/null
pnpm add some-active-package   # observe it resolves an aged version, not a <1-day-old one
```
Expected: pnpm picks a version ≥1 day old.

- [ ] **Step 2: Socket wrapper active** — `alias pnpm` shows `sfw pnpm`; an install runs through Socket.

- [ ] **Step 3: Confirm globals** — `npm config get ignore-scripts allow-git min-release-age` and `pnpm config get minimumReleaseAge blockExoticSubdeps` and `go env GOFLAGS` all return the hardened values.

- [ ] **Step 4: Confirm the shipping repos** — `pnpm gate` green in `git-org/app`; `pnpm run build && pnpm run test` green in `projects/`; `cargo deny check` green across Rust repos.

---

## Self-review checklist (done by author)

- [x] All 7 mitigations have tasks: cooldown (1.1/1.2/2.2/3.2), disable-scripts (1.1/2.1), block-git (1.1/1.2), scan (1.5/1.6/3.3), lockfile (3.1 pnpm-immune + template 1.7), clean-install (2.2/3.1/3.3), habits (1.7).
- [x] Cross-ecosystem: Socket aliases (1.6) + metapac tools (1.5) cover Rust/Python; Go via go env (1.3) + govulncheck (1.5).
- [x] No fabricated config keys — npm keys verified on 11.12.1, pnpm globals verified honored. The one unconfirmed key (trust policy) is isolated in Task 5.1 with an explicit lookup step and marked non-blocking.
- [x] Exact paths and commands throughout; file contents inline.
