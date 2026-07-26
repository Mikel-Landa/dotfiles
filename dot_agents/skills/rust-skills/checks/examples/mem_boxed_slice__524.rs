#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::mem::size_of;

// Vec: 24 bytes on 64-bit
assert_eq!(size_of::<Vec<u8>>(), 24);  // ptr(8) + len(8) + cap(8)

// Box<[T]>: 16 bytes (fat pointer)
assert_eq!(size_of::<Box<[u8]>>(), 16);  // ptr(8) + len(8)

// Savings per instance: 8 bytes
// For 1 million instances: 8 MB saved
;
Ok(())
}
fn main() {}
