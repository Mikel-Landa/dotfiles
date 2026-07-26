#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Arc::clone is cheap - just increments atomic counter
let a = Arc::new(large_data);
let b = Arc::clone(&a);  // Fast! No data copied

// But atomic operations have overhead vs Rc
// Use Rc in single-threaded contexts for better performance

// Avoid cloning Arc in hot loops if possible
// Bad:
for item in items {
    let arc = Arc::clone(&shared);  // Atomic op each iteration
    process(arc, item);
}

// Better: Clone once outside loop if possible
let arc = Arc::clone(&shared);
for item in items {
    process(&arc, item);  // Pass reference
}
;
Ok(())
}
fn main() {}
