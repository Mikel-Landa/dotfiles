#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn search(data: &[i32], target: i32) -> Option<usize> {
    for (i, &item) in data.iter().enumerate() {
        // Assume most iterations DON'T find the target
        if unlikely(item == target) {
            return Some(i);
        }
    }
    None
}

// Alternative: structure for likely case
fn search_common(data: &[i32], target: i32) -> Option<usize> {
    // If target is usually found
    for (i, &item) in data.iter().enumerate() {
        if likely(item == target) {
            return Some(i);
        }
    }
    None
}
;
Ok(())
}
fn main() {}
