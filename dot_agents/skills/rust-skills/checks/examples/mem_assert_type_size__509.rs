#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// ✅ Types stored in large collections
struct Node { /* ... */ }
const _: () = assert!(std::mem::size_of::<Node>() <= 64);

// ✅ Types used in FFI / binary protocols
#[repr(C)]
struct WireFormat { /* ... */ }
const _: () = assert!(std::mem::size_of::<WireFormat>() == 256);

// ✅ Performance-critical types
struct HotPath { /* ... */ }
const _: () = assert!(std::mem::size_of::<HotPath>() <= 128);

// ❌ Skip for rarely-instantiated types
struct AppConfig { /* many fields */ }
// Size doesn't matter, only one instance
;
Ok(())
}
fn main() {}
