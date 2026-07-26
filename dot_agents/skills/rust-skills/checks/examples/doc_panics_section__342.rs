#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
/// Creates a new buffer with the given capacity.
///
/// # Panics
///
/// Panics if `capacity` is zero. A buffer must have at least
/// one byte of capacity.
///
/// This panics rather than returning an error because a zero-capacity
/// buffer represents a programming error, not a runtime condition.
pub fn new(capacity: usize) -> Self {
    assert!(capacity > 0, "capacity must be non-zero");
    // ...
}
;
Ok(())
}
fn main() {}
