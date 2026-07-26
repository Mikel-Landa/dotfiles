#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Before (complexity warnings)
fn find_positive(nums: &[i32]) -> Option<i32> {
    let filtered: Vec<_> = nums.iter()
        .cloned()
        .filter(|x| *x > 0)
        .collect();
    if filtered.len() == 0 {
        None
    } else {
        Some(filtered[0])
    }
}

// After (simplified)
fn find_positive(nums: &[i32]) -> Option<i32> {
    nums.iter()
        .copied()
        .find(|&x| x > 0)
}
;
Ok(())
}
fn main() {}
