#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::fmt::Write;

let mut output = String::new();

// writeln! adds newline automatically
writeln!(&mut output, "Line 1: {}", value1).unwrap();
writeln!(&mut output, "Line 2: {}", value2).unwrap();

// Equivalent to
write!(&mut output, "Line 1: {}\n", value1).unwrap();
;
Ok(())
}
fn main() {}
