#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
let mut vec = vec![1, 2, 3, 4, 5];

// clear(): keeps capacity, O(n) for Drop types
vec.clear();
assert_eq!(vec.len(), 0);
assert!(vec.capacity() >= 5);

// drain(): returns iterator, clears after iteration
let drained: Vec<_> = vec.drain(..).collect();

// truncate(): keeps first n elements
vec.truncate(2);

// Creating new: loses all capacity
vec = Vec::new();  // Capacity gone
;
Ok(())
}
fn main() {}
