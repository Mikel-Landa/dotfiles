#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use ecow::EcoString;

// Clone is O(1) - shares underlying data
let s1: EcoString = "shared data".into();
let s2 = s1.clone();  // Cheap, shares allocation

// Copy-on-write: only allocates on mutation
let mut s3 = s1.clone();
s3.push_str(" modified");  // Now allocates
;
Ok(())
}
fn main() {}
