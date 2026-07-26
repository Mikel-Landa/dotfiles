#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// SmallVec is slightly larger than Vec
use std::mem::size_of;
// Vec<i32>: 24 bytes (ptr + len + cap)
// SmallVec<[i32; 4]>: 32 bytes (inline storage + len + discriminant)

// SmallVec has branching overhead on every operation
// (must check if inline or heap)

// Profile to verify benefit!
;
Ok(())
}
fn main() {}
