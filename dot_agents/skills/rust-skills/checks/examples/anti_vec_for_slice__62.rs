#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Bad
fn double(numbers: &mut Vec<i32>) {
    for n in numbers.iter_mut() {
        *n *= 2;
    }
}

// Good
fn double(numbers: &mut [i32]) {
    for n in numbers.iter_mut() {
        *n *= 2;
    }
}
;
Ok(())
}
fn main() {}
