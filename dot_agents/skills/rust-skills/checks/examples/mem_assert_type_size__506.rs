#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// No external crate needed (Rust 1.57+)
struct Packet {
    header: u32,
    payload: [u8; 60],
}

const _: () = assert!(
    std::mem::size_of::<Packet>() == 64,
    "Packet must be exactly 64 bytes for protocol compliance"
);

// Compile error shows custom message if assertion fails
;
Ok(())
}
fn main() {}
