#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::num::NonZeroU64;

// Option<u64> = 16 bytes (no null pointer optimization)
assert_eq!(size_of::<Option<u64>>(), 16);

// Option<NonZeroU64> = 8 bytes (0 represents None)
assert_eq!(size_of::<Option<NonZeroU64>>(), 8);

let id: Option<NonZeroU64> = NonZeroU64::new(42);
;
Ok(())
}
fn main() {}
