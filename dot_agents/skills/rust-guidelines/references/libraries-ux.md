# Libraries / UX Guidelines

> Source: https://microsoft.github.io/rust-guidelines/agents/all.txt

Open only the rule needed for the current Rust task.

- [`M-ASYNC-FN`](rules/m-async-fn.md) — Functions are `async` over returning a Future — simpler code and easier-to-understand APIs.
- [`M-AVOID-WRAPPERS`](rules/m-avoid-wrappers.md) — Avoid smart pointers and wrappers in APIs — low cognitive load and ergonomic APIs.
- [`M-BALANCED-MODULES`](rules/m-balanced-modules.md) — Modules are balanced in size and scope — discoverable functionality and clear API usage.
- [`M-COLLECTION-TRAITS`](rules/m-collection-traits.md) — Collections implement the appropriate iter traits — composable collections.
- [`M-DI-HIERARCHY`](rules/m-di-hierarchy.md) — Prefer types over generics, generics over dyn traits — composable patterns and freedom from design lock-in.
- [`M-ERRORS-CANONICAL-STRUCTS`](rules/m-errors-canonical-structs.md) — Errors are canonical structs — harmonized error types and consistent error handling.
- [`M-ESSENTIAL-FN-INHERENT`](rules/m-essential-fn-inherent.md) — Essential functionality should be inherent — easily discoverable essential functionality.
- [`M-FROM-ERROR`](rules/m-from-error.md) — Canonical error conversion uses `From`, not `map_err` — idiomatic error handling.
- [`M-INIT-BUILDER`](rules/m-init-builder.md) — Complex type construction has builders — future-proof type construction in complex scenarios.
- [`M-INIT-CASCADED`](rules/m-init-cascaded.md) — Complex type initialization hierarchies are cascaded — construction free of parameter mix-ups.
- [`M-NO-PRELUDE`](rules/m-no-prelude.md) — Don't define preludes — a clean namespace and reliable downstream builds.
- [`M-PARAMETER-CONSISTENCY`](rules/m-parameter-consistency.md) — Parameter ordering is consistent — low development friction.
- [`M-SERVICES-CLONE`](rules/m-services-clone.md) — Services are Clone — composable sharing of common services.
- [`M-SIMPLE-ABSTRACTIONS`](rules/m-simple-abstractions.md) — Abstractions don't visibly nest — low cognitive load and a good out-of-the-box UX.
