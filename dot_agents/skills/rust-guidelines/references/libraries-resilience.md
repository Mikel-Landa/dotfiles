# Libraries / Resilience Guidelines

> Source: https://microsoft.github.io/rust-guidelines/agents/all.txt

Open only the rule needed for the current Rust task.

- [`M-AVOID-STATICS`](rules/m-avoid-statics.md) — Avoid statics — consistency and correctness across crate versions.
- [`M-BUILD-RESULT`](rules/m-build-result.md) — Builders validate in final `.build()` — clean builder error handling.
- [`M-INTEGRATION-TESTS`](rules/m-integration-tests.md) — Integration tests live under `tests/` — clean code files.
- [`M-LOG-NOT-PRINT`](rules/m-log-not-print.md) — Production code uses telemetry, not println — diagnostics available where they are needed.
- [`M-MOCKABLE-SYSCALLS`](rules/m-mockable-syscalls.md) — I/O and system calls are mockable — testable edge cases that are otherwise hard to evoke.
- [`M-NO-GLOB-REEXPORTS`](rules/m-no-glob-reexports.md) — Don't glob re-export items — a deliberate public surface.
- [`M-STRONG-TYPES-GUARD`](rules/m-strong-types-guard.md) — Newtypes guard their invariants — centralized correctness invariants.
- [`M-STRONG-TYPES`](rules/m-strong-types.md) — Use the proper type family — the right data and safety invariants, at the right time.
- [`M-TEST-UTIL`](rules/m-test-util.md) — Test utilities are feature gated — production builds that cannot bypass safety checks.
