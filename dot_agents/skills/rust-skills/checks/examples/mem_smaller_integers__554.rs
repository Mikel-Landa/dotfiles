#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::mem::size_of;

// Poor ordering - 24 bytes due to padding
struct Wasteful {
    a: u8,    // 1 byte + 7 padding
    b: u64,   // 8 bytes
    c: u8,    // 1 byte + 7 padding
}
assert_eq!(size_of::<Wasteful>(), 24);

// Better ordering - 16 bytes
struct Efficient {
    b: u64,   // 8 bytes (aligned)
    a: u8,    // 1 byte
    c: u8,    // 1 byte + 6 padding
}
assert_eq!(size_of::<Efficient>(), 16);

// Even better with smaller types - 10 bytes
struct Compact {
    b: u32,   // 4 bytes (if u32 suffices)
    a: u8,    // 1 byte
    c: u8,    // 1 byte
}
assert_eq!(size_of::<Compact>(), 8);  // With padding
;
Ok(())
}
fn main() {}
