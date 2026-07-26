#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::mem::{size_of, align_of};

#[repr(transparent)]
struct Meters(f64);

// Same size
assert_eq!(size_of::<Meters>(), size_of::<f64>());

// Same alignment
assert_eq!(align_of::<Meters>(), align_of::<f64>());

// Same ABI - can pass where f64 expected
extern "C" fn measure(distance: Meters) { ... }
;
Ok(())
}
fn main() {}
