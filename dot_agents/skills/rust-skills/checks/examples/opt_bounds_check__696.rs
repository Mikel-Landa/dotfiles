#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn parallel_sum(data: &[i32]) -> i32 {
    // Split into independent chunks
    let (left, right) = data.split_at(data.len() / 2);
    
    // Process chunks without bounds checks
    let sum_left: i32 = left.iter().sum();
    let sum_right: i32 = right.iter().sum();
    
    sum_left + sum_right
}
;
Ok(())
}
fn main() {}
