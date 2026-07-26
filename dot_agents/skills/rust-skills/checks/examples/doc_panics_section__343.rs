#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
/// Adds an item to the collection.
///
/// # Panics
///
/// In debug builds, panics if the collection is at capacity.
/// In release builds, this is a no-op when at capacity.
pub fn push(&mut self, item: T) {
    debug_assert!(self.len < self.capacity, "collection at capacity");
    // ...
}
;
Ok(())
}
fn main() {}
