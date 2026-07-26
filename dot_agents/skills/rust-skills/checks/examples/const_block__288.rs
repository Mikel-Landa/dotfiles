#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
const SIZE: usize = 64;

fn process(buf: &[u8]) {
    // compile-time assertion — build fails immediately if SIZE changes to a bad value
    const { assert!(SIZE.is_power_of_two(), "SIZE must be a power of two") };

    // runtime assertion for dynamic data still makes sense here
    assert!(buf.len() <= SIZE);
}

// inline const block used as a value — evaluated once, inlined at each use
fn magic_header() -> u32 {
    const { 0xDEAD_BEEFu32.swap_bytes() }
}

// compile-time bounds check on a type-level relationship
struct Packet<const HDR: usize, const BODY: usize>;

impl<const HDR: usize, const BODY: usize> Packet<HDR, BODY> {
    fn new() -> Self {
        // fails at compile time if the relationship is violated, not at runtime
        const { assert!(HDR + BODY <= 1500, "packet exceeds ethernet MTU") };
        Packet
    }
}

// array of non-Copy type using a const block per element
// (each element is its own const expression — legal since 1.79)
fn make_table() -> [u64; 4] {
    [
        const { u64::MAX / 1 },
        const { u64::MAX / 2 },
        const { u64::MAX / 3 },
        const { u64::MAX / 4 },
    ]
}
;
Ok(())
}
fn main() {}
