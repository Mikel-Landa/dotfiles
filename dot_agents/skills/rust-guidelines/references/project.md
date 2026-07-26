# Project Guidelines

> Source: https://microsoft.github.io/rust-guidelines/agents/all.txt

Open only the rule needed for the current Rust task.

- [`M-CARGO-WORKSPACE`](rules/m-cargo-workspace.md) — Common settings come from the workspace Cargo.toml — consistent, maintainable project configuration.
- [`M-CRATES-FLAT-FOLDER`](rules/m-crates-flat-folder.md) — All crates are siblings in one folder — simple project navigation and a standard Rust layout.
- [`M-CRATES-IN-WORKSPACE`](rules/m-crates-in-workspace.md) — The workspace lists and versions all crates — simple inter-crate dependencies and debugging.
- [`M-LATEST-EDITION`](rules/m-latest-edition.md) — New crates target latest edition — access to the latest Rust features.
- [`M-MSRV`](rules/m-msrv.md) — MSRV is conservatively updated — modern features with stability for users.
