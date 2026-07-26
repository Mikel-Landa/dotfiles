#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// At the top of lib.rs or main.rs
#![deny(clippy::correctness)]

// Or in Cargo.toml for workspace-wide
[lints.clippy]
correctness = "deny"
fn main() {}
