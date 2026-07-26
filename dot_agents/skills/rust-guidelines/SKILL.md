---
name: rust-guidelines
description: Microsoft Pragmatic Rust Guidelines for coding agents. Use only when actively creating, modifying, reviewing, debugging, testing, benchmarking, documenting, or configuring Rust code, Cargo crates/workspaces, Rust macros, or Rust-facing FFI. Do not use for non-Rust tasks or merely because a repository contains Rust.
---

# Pragmatic Rust Guidelines

Apply these guidelines only while building with Rust. Project instructions and explicit user requirements take precedence.

## Workflow

1. Confirm the task changes Rust code or a Rust-facing artifact (`Cargo.toml`, workspace configuration, macros, FFI, Rust API docs). Otherwise, do not use this skill.
2. Identify the work surface from the routing table.
3. Open only the relevant reference file and only the needed rule section. Follow cross-referenced rule IDs when they affect the change.
4. Use `references/index.md` only for rule discovery or an exhaustive audit.
5. Preserve rule IDs in review findings when useful, but do not add guideline-compliance reports or design-process narratives to user-facing docs.

## Reference routing

| Work surface | Reference |
| --- | --- |
| Agent-friendly Rust APIs and tests | `references/ai.md` |
| Binaries, service apps, allocators, deployment CPU | `references/applications.md` |
| Panics, unsafe code, soundness, initialization | `references/correctness.md` |
| Rustdoc, module docs, examples | `references/documentation.md` |
| ABI, dynamic libraries, native handles | `references/ffi.md` |
| Library-wide guidance placeholder | `references/library.md` |
| Declarative and procedural macros | `references/macros.md` |
| Allocation, async, locking, inlining, benchmarking | `references/performance.md` |
| Cargo workspaces, crates, editions, MSRV | `references/project.md` |
| Safety guidance placeholder | `references/safety.md` |
| Naming, logging, lints, tests, dependencies, source layout | `references/universal.md` |
| Library build scripts, features, dependencies | `references/libraries-building.md` |
| Library APIs, ownership, async, interop | `references/libraries-interop.md` |
| Cancellation, statics, resilience, timeouts | `references/libraries-resilience.md` |
| Public API design, errors, builders, services | `references/libraries-ux.md` |

## Loading discipline

- Never load every reference by default.
- Start with one routed file; read a specific rule section or a narrow line range when possible.
- Load `universal.md` only for its cross-cutting concern, not automatically for every Rust task.
- For a comprehensive review, use `references/index.md` as the checklist and inspect category files sequentially.

## Source

Converted from Microsoft's [Pragmatic Rust Guidelines agent bundle](https://microsoft.github.io/rust-guidelines/agents/all.txt), copyright Microsoft Corporation, MIT licensed. Reference files preserve the source wording and rule IDs.
