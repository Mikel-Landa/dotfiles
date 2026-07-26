#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// WARN: Suspicious use of not on a bool
let inverted = !x as i32;  // Did you mean (!x) as i32 or !(x as i32)?

// WARN: Cast of float to int may lose precision
let n = 3.14_f64 as i32;  // May want .round() first
;
Ok(())
}
fn main() {}
