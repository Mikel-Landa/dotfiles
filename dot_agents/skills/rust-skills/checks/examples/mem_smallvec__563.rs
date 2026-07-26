#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use arrayvec::ArrayVec;

// Fixed maximum capacity, never heap allocates
// Panics if you exceed capacity
fn parse_rgb(s: &str) -> ArrayVec<u8, 3> {
    let mut components = ArrayVec::new();
    for part in s.split(',').take(3) {
        components.push(part.parse().unwrap());
    }
    components
}
;
Ok(())
}
fn main() {}
