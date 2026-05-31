# lockfile-lint (only needed for npm/yarn/bun repos — pnpm is not vulnerable to lockfile injection)

Install: `pnpm add -D lockfile-lint`  (or npm i -D)

CI check:
    npx lockfile-lint --path package-lock.json --type npm \
      --allowed-hosts npm --validate-https --validate-package-names

Fails the build if a resolved URL points off-registry or a name/host mismatches.
