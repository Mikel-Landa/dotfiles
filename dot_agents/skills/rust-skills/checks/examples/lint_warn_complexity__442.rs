#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// High cognitive load
let value = if x.is_some() { x.unwrap() } else { y.unwrap_or(z) };

// Lower cognitive load
let value = x.unwrap_or_else(|| y.unwrap_or(z));
;
Ok(())
}
fn main() {}
