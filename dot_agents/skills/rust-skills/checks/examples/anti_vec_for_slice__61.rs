#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn takes_slice(s: &[i32]) { }

let vec = vec![1, 2, 3];
takes_slice(&vec);  // &Vec<i32> -> &[i32] via Deref
;
Ok(())
}
fn main() {}
