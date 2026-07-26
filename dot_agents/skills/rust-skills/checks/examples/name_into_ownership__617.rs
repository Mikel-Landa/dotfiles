#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
let vec = vec![1, 2, 3];

// into_iter consumes the collection
for item in vec.into_iter() {  // or just: for item in vec
    // item is i32, not &i32
}
// vec is consumed, can't use anymore

// Contrast with iter() which borrows
let vec = vec![1, 2, 3];
for item in vec.iter() {
    // item is &i32
}
// vec still usable
;
Ok(())
}
fn main() {}
