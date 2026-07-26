# FFI Guidelines

> Source: https://microsoft.github.io/rust-guidelines/agents/all.txt

Open only the rule needed for the current Rust task.

- [`M-FFI-NAMING`](rules/m-ffi-naming.md) — FFI crates follow established naming conventions — immediately recognizable crate roles across projects.
- [`M-FFI-TRANSLATES`](rules/m-ffi-translates.md) — Business logic belongs in core crates, FFI only translates — maximal safe code and a clean separation of concerns.
- [`M-ISOLATE-DLL-STATE`](rules/m-isolate-dll-state.md) — Isolate DLL state between FFI libraries — data integrity and defined behavior across DLL boundaries.
