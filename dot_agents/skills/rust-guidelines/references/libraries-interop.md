# Libraries / Interoperability Guidelines

> Source: https://microsoft.github.io/rust-guidelines/agents/all.txt

Open only the rule needed for the current Rust task.

- [`M-DONT-LEAK-TYPES`](rules/m-dont-leak-types.md) — Don't leak external types — stable APIs and low long-term maintenance cost.
- [`M-ESCAPE-HATCHES`](rules/m-escape-hatches.md) — Native escape hatches — workarounds for unsupported use cases until alternatives exist.
- [`M-FOREIGN-REEXPORTS`](rules/m-foreign-reexports.md) — Items come from their original crate — unambiguous type identity.
- [`M-IMPL-ASREF`](rules/m-impl-asref.md) — Accept `impl AsRef<>` where feasible — flexibility for callers to use their own types.
- [`M-IMPL-IO`](rules/m-impl-io.md) — Accept `impl 'IO'` where feasible ('sans IO') — business logic untangled from I/O, with N*M composability.
- [`M-IMPL-RANGEBOUNDS`](rules/m-impl-rangebounds.md) — Accept `impl RangeBounds<>` where feasible — flexibility and clarity when specifying ranges.
- [`M-TYPES-SEND`](rules/m-types-send.md) — Types are Send — use in Tokio and behind runtime abstractions.
