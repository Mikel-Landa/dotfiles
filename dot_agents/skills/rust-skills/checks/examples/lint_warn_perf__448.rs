#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Unnecessary allocation
let vec: Vec<i32> = vec![];  // Creates capacity
let vec: Vec<i32> = Vec::new();  // No allocation

// Pre-allocation
let mut vec = Vec::with_capacity(100);  // One allocation
for i in 0..100 {
    vec.push(i);  // No reallocation
}
;
Ok(())
}
fn main() {}
