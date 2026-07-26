#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Stack: fast allocation, limited size, moves copy bytes
struct StackHeavy {
    data: [u8; 4096],  // 4KB on stack
}

// Heap: allocation cost, unlimited size, moves copy pointer
struct HeapLight {
    data: Box<[u8; 4096]>,  // 8 bytes on stack, 4KB on heap
}

// Measure with size_of
use std::mem::size_of;
assert_eq!(size_of::<StackHeavy>(), 4096);
assert_eq!(size_of::<HeapLight>(), 8);
;
Ok(())
}
fn main() {}
