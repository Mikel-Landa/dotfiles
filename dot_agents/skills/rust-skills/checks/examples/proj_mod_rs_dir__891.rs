#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// src/database/mod.rs
mod connection;
mod migrations;
mod queries;
mod error;

pub use connection::Pool;
pub use error::DatabaseError;
pub use queries::{UserQueries, OrderQueries};
fn main() {}
