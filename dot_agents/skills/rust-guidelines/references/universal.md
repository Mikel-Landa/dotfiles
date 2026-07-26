# Universal Guidelines

> Source: https://microsoft.github.io/rust-guidelines/agents/all.txt

Open only the rule needed for the current Rust task.

- [`M-DOCUMENTED-MAGIC`](rules/m-documented-magic.md) — Magic values are documented — maintainability and safe refactoring.
- [`M-LINT-OVERRIDE-EXPECT`](rules/m-lint-override-expect.md) — Lint overrides should use `#[expect]` — a current, tidy lint set.
- [`M-LOG-STRUCTURED`](rules/m-log-structured.md) — Use structured logging with message templates — low-cost logging with strong filtering.
- [`M-PUBLIC-DEBUG`](rules/m-public-debug.md) — Public types are Debug — easy debugging without leaking sensitive data.
- [`M-PUBLIC-DISPLAY`](rules/m-public-display.md) — Public types meant to be read are Display — usability.
- [`M-REGULAR-FN`](rules/m-regular-fn.md) — Prefer regular over associated functions — readability.
- [`M-SHORT-NAMES`](rules/m-short-names.md) — Names of items are short — idiomatic code.
- [`M-SMALLER-CRATES`](rules/m-smaller-crates.md) — If in doubt, split the crate — fast compile times and good modularity.
- [`M-STATIC-VERIFICATION`](rules/m-static-verification.md) — Use static verification — consistency and freedom from common issues.
- [`M-UPSTREAM-GUIDELINES`](rules/m-upstream-guidelines.md) — Follow the upstream guidelines — a codebase that reflects community lessons and does not surprise users or contributors.
- [`M-WEASEL-WORDS`](rules/m-weasel-words.md) — Names are free of weasel words — readability.
