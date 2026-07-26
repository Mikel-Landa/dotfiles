#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tinyvec::{tiny_vec, TinyVec};

// Same concept as SmallVec but 100% safe code
let v: TinyVec<[i32; 4]> = tiny_vec![1, 2, 3];
;
Ok(())
}
fn main() {}
