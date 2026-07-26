#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use thin_vec::{ThinVec, thin_vec};

// Constructor macro
let v: ThinVec<i32> = thin_vec![1, 2, 3];

// Familiar Vec-like API
let mut v = ThinVec::new();
v.push(1);
v.push(2);
v.extend([3, 4, 5]);
v.pop();

// Iteration
for item in &v {
    println!("{}", item);
}

// Slicing
let slice: &[i32] = &v[..];

// Conversion
let vec: Vec<i32> = v.into();
let thin: ThinVec<i32> = vec.into();
;
Ok(())
}
fn main() {}
