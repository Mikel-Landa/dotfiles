# Macros Guidelines

> Source: https://microsoft.github.io/rust-guidelines/agents/all.txt

Open only the rule needed for the current Rust task.

- [`M-EXAMPLE-OVER-PROC`](rules/m-example-over-proc.md) — Prefer 'macros by example' over proc macros — easy macro inspection and fast compilation.
- [`M-MACRO-HELPERS`](rules/m-macro-helpers.md) — Third party items come from hidden `_private` module — predictable compilation.
- [`M-MACRO-LAST-RESORT`](rules/m-macro-last-resort.md) — Macros are a last resort — minimal complexity.
- [`M-MACRO-MAIN-CRATE`](rules/m-macro-main-crate.md) — Macros assume main crate — simple macro logic.
- [`M-MACROS-DONT-LIE`](rules/m-macros-dont-lie.md) — Macros don't lie about signatures — clarity for users and LLMs.
- [`M-PROC-IMPL`](rules/m-proc-impl.md) — Proc macros should have separate impl crate incl. tests — thoroughly testable proc macros.
- [`M-PROC-IMPLIED-ITEMS`](rules/m-proc-implied-items.md) — Proc macros don't produce implied or hidden items — clear errors and correct hygiene and visibility.
