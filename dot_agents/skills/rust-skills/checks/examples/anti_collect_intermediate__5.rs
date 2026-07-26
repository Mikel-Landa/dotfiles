#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Single allocation, single pass
fn process(data: Vec<i32>) -> Vec<i32> {
    data.into_iter()
        .filter(|x| *x > 0)
        .map(|x| x * 2)
        .filter(|x| *x < 100)
        .collect()
}

// No allocation - iterator short-circuits
fn has_valid_items(items: &[Item]) -> bool {
    items.iter().any(|i| i.is_valid())
}

// No intermediate allocation
fn sum_valid(items: &[Item]) -> i64 {
    items.iter()
        .filter(|i| i.is_valid())
        .map(|i| i.value)
        .sum()
}
;
Ok(())
}
fn main() {}
