#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// CPU-intensive operations
- Cryptographic operations (hashing, encryption)
- Image/video processing
- Compression/decompression
- Complex parsing
- Mathematical computations

// Blocking I/O
- std::fs operations
- Synchronous database drivers
- Synchronous HTTP clients
- Thread::sleep

// Example thresholds (rough guidelines):
// < 10µs: OK on async thread
// 10µs - 1ms: Consider spawn_blocking
// > 1ms: Definitely spawn_blocking
;
Ok(())
}
fn main() {}
