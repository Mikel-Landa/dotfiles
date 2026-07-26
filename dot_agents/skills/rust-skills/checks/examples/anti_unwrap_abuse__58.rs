#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// Enable these lints to catch unwrap usage:
#![warn(clippy::unwrap_used)]
#![warn(clippy::expect_used)]  // Stricter

// Or per-function:
#[allow(clippy::unwrap_used)]
fn tests_only() { }
fn main() {}
