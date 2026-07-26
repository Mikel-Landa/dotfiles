#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use arrayvec::ArrayString;
use std::fmt::Write; // brings the write! target trait into scope

// Stack-allocated string with max capacity
let mut s: ArrayString<64> = ArrayString::new();
s.push_str("Hello, ");
s.push_str("world!");

// No heap allocation for small strings
fn format_code(code: u32) -> ArrayString<16> {
    let mut s = ArrayString::new();
    write!(&mut s, "CODE-{:04}", code).unwrap();
    s
}
;
Ok(())
}
fn main() {}
