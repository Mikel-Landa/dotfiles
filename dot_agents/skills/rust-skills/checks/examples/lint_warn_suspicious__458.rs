#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// WARN: Almost swapped operands in a comparison
if 5 < x && x < 3 { }  // Impossible condition

// WARN: Suspicious assignment in a condition
if (x = 5) { }  // Probably meant x == 5
;
Ok(())
}
fn main() {}
