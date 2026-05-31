# Go supply-chain checklist (new repos)
- Globals already set via ~/.config/go/env (GOFLAGS=-mod=readonly, proxy, sumdb).
- Commit go.mod + go.sum.
- `govulncheck ./...` in CI.
- `osv-scanner -r .` for broader advisory coverage.
- Socket Firewall Free does NOT cover Go (Enterprise only) — govulncheck is the install-time check.
