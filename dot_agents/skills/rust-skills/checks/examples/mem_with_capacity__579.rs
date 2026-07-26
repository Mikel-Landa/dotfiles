#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Unknown size, small expected
let mut small: Vec<i32> = Vec::new();  // OK for small collections

// Using collect() with good size_hint
let v: Vec<_> = iter.collect();  // collect() uses size_hint

// Capacity overhead exceeds benefit
let mut rarely_used = Vec::new();  // OK if rarely grown
;
Ok(())
}
fn main() {}
