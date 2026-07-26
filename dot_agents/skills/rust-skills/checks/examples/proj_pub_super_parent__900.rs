#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// src/database/mod.rs
mod connection;
mod query;
mod pool;

// Only this module's children can see
pub(super) struct RawConnection { /* ... */ }

// Entire crate can see
pub(crate) struct Pool { /* ... */ }

// Everyone can see
pub struct Database { /* ... */ }
fn main() {}
