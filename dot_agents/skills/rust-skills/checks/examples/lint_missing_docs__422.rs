#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
#![warn(missing_docs)]

struct Internal { }  // No warning - private

pub struct Public { }  // WARN - public, needs docs
fn main() {}
