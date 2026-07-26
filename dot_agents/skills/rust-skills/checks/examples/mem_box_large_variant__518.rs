#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::mem::size_of;

// Before boxing
enum BadEvent {
    Click { x: u32, y: u32 },           // 8 bytes
    KeyPress(char),                      // 4 bytes
    LargeData([u8; 256]),               // 256 bytes
}
println!("BadEvent: {} bytes", size_of::<BadEvent>());  // ~264 bytes

// After boxing
enum GoodEvent {
    Click { x: u32, y: u32 },
    KeyPress(char),
    LargeData(Box<[u8; 256]>),          // 8 bytes (pointer)
}
println!("GoodEvent: {} bytes", size_of::<GoodEvent>());  // ~16 bytes
;
Ok(())
}
fn main() {}
