#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use memchr::memchr;

// Fast byte search using SIMD
fn find_newline(data: &[u8]) -> Option<usize> {
    memchr(b'\n', data)  // SIMD-accelerated, no allocation
}

// Find all occurrences
use memchr::memchr_iter;

fn count_newlines(data: &[u8]) -> usize {
    memchr_iter(b'\n', data).count()
}
;
Ok(())
}
fn main() {}
