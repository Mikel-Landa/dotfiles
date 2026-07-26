#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use static_assertions::{assert_eq_size, const_assert};

struct Critical {
    id: u64,
    flags: u32,
    data: [u8; 16],
}

// Exact size assertion
assert_eq_size!(Critical, [u8; 32]);

// Maximum size assertion
const_assert!(std::mem::size_of::<Critical>() <= 64);

// Alignment assertion
const_assert!(std::mem::align_of::<Critical>() == 8);

// Compare sizes
assert_eq_size!(Critical, [u64; 4]);
;
Ok(())
}
fn main() {}
