#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::mem::size_of;

// All 24 bytes, but different inline capacities
assert_eq!(size_of::<String>(), 24);
assert_eq!(size_of::<compact_str::CompactString>(), 24);
assert_eq!(size_of::<smartstring::SmartString>(), 24);
assert_eq!(size_of::<ecow::EcoString>(), 16);  // Even smaller!
;
Ok(())
}
fn main() {}
