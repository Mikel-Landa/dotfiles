#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::mem::size_of;

// Standard Vec: always 24 bytes
assert_eq!(size_of::<Vec<u8>>(), 24);
assert_eq!(size_of::<Option<Vec<u8>>>(), 24);  // No NPO benefit

// ThinVec: 8 bytes (one pointer)
use thin_vec::ThinVec;
assert_eq!(size_of::<ThinVec<u8>>(), 8);
assert_eq!(size_of::<Option<ThinVec<u8>>>(), 8);  // Option is free!
;
Ok(())
}
fn main() {}
