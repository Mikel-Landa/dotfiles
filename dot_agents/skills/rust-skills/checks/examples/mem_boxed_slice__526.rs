#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::mem::size_of;

// String: 24 bytes (like Vec<u8>)
assert_eq!(size_of::<String>(), 24);

// Box<str>: 16 bytes
assert_eq!(size_of::<Box<str>>(), 16);

// For immutable strings
struct Name {
    value: Box<str>,  // Saves 8 bytes vs String
}

impl Name {
    fn new(s: &str) -> Self {
        Name { value: s.into() }  // &str -> Box<str>
    }
}

// Or from String
let s = String::from("hello");
let boxed: Box<str> = s.into_boxed_str();
;
Ok(())
}
fn main() {}
