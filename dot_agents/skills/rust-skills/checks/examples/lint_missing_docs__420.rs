#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
#![warn(missing_docs)]

pub struct User {  // WARN: missing documentation for a struct
    pub name: String,  // WARN: missing documentation for a field
    pub age: u32,      // WARN: missing documentation for a field
}

pub fn process() { }  // WARN: missing documentation for a function

pub trait Handler {  // WARN: missing documentation for a trait
    fn handle(&self);  // WARN: missing documentation for a method
}
fn main() {}
