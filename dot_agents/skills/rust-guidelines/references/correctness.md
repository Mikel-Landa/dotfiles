# Correctness Guidelines

> Source: https://microsoft.github.io/rust-guidelines/agents/all.txt

Open only the rule needed for the current Rust task.

- [`M-PANIC-CONTINUATION`](rules/m-panic-continuation.md) — Panic continuation is last resort — state integrity and freedom from subtle bugs.
- [`M-PANIC-IS-STOP`](rules/m-panic-is-stop.md) — Panic means 'stop the program' — soundness and predictability.
- [`M-PANIC-MESSAGE`](rules/m-panic-message.md) — Custom panics have a helpful message — faster bug diagnosis.
- [`M-PANIC-ON-BUG`](rules/m-panic-on-bug.md) — Detected programming bugs are panics, not errors — tractable error handling and runtime consistency.
- [`M-UNSAFE-IMPLIES-UB`](rules/m-unsafe-implies-ub.md) — Unsafe implies undefined behavior — semantic consistency without warning fatigue.
- [`M-UNSAFE`](rules/m-unsafe.md) — Unsafe needs reason, should be avoided — memory safety and a minimal attack surface.
- [`M-UNSOUND`](rules/m-unsound.md) — All code must be sound — predictable runtime behavior free of bugs and incompatibilities.
