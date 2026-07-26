#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// std::Option - must_use on map, and, or
let x: Option<i32> = Some(5);
x.map(|v| v * 2);  // Warning: unused return value

// std::Result - must_use on the type itself
#[must_use = "this `Result` may be an `Err` variant, which should be handled"]
pub enum Result<T, E> { ... }

// Iterator adaptors
let v = vec![1, 2, 3];
v.iter().map(|x| x * 2);  // Warning: iterators are lazy
;
Ok(())
}
fn main() {}
