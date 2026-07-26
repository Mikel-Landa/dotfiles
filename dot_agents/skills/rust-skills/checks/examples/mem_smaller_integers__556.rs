#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use bitflags::bitflags;

// Instead of 8 separate bool fields (8 bytes minimum)
bitflags! {
    struct Permissions: u8 {
        const READ    = 0b0000_0001;
        const WRITE   = 0b0000_0010;
        const EXECUTE = 0b0000_0100;
        const DELETE  = 0b0000_1000;
    }
}
// All 8 flags in 1 byte!

let perms = Permissions::READ | Permissions::WRITE;
if perms.contains(Permissions::READ) {
    // ...
}
;
Ok(())
}
fn main() {}
