# Performance Guidelines

> Source: https://microsoft.github.io/rust-guidelines/agents/all.txt

Open only the rule needed for the current Rust task.

- [`M-ASYNC-STACK-SIZE`](rules/m-async-stack-size.md) — Hot `async` functions reduce stack size — small async stack sizes and low memcpy overhead.
- [`M-AVOID-INDIRECTION`](rules/m-avoid-indirection.md) — Nested type hierarchies should avoid needless indirection — fast, cache-friendly memory access.
- [`M-BOX-DST`](rules/m-box-dst.md) — Use boxed slices and strings for immutable owned sequences — low memory consumption and good cache utilization.
- [`M-FAST-HASHER`](rules/m-fast-hasher.md) — Use a fast hasher where possible — hashing performance.
- [`M-HOTPATH`](rules/m-hotpath.md) — Identify, profile, optimize the hot path early — high-performance code.
- [`M-INITIAL-CAPACITY`](rules/m-initial-capacity.md) — Collections are created with sufficient initial capacity — efficient collection creation.
- [`M-LOG-OVERHEAD`](rules/m-log-overhead.md) — Library telemetry does not tank performance — low-overhead telemetry during diagnosis.
- [`M-MEM-REUSE`](rules/m-mem-reuse.md) — Reuse allocations where possible — low allocation overhead and fast hot paths.
- [`M-SHRINK-TO-FIT`](rules/m-shrink-to-fit.md) — Shrink collections to fit after building — a minimal memory footprint.
- [`M-THROUGHPUT`](rules/m-throughput.md) — Optimize for throughput, avoid empty cycles — COGS savings at scale.
- [`M-YIELD-POINTS`](rules/m-yield-points.md) — Long-running tasks should have yield points — fair CPU time for all tasks.
