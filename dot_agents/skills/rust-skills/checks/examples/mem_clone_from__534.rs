#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Single clone - no benefit
let copy = original.clone();  // Can't reuse, no prior allocation

// Small Copy types - no allocation anyway
let x: i32 = y;  // Not even Clone, just Copy

// Immutable context
fn process(data: &String) {
    // Can't use clone_from - would need &mut self
}
;
Ok(())
}
fn main() {}
