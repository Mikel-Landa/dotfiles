#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Single chain, single collect
fn process(data: Vec<i32>) -> Vec<i32> {
    data.into_iter()
        .filter(|x| *x > 0)
        .map(|x| x * 2)
        .take(10)
        .collect()
}

// Short-circuits on first match
fn has_positive(data: &[i32]) -> bool {
    data.iter().any(|&x| x > 0)
}
;
Ok(())
}
fn main() {}
