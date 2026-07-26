#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Accept slice - works with Vec, arrays, slices
fn sum(numbers: &[i32]) -> i32 {
    numbers.iter().sum()
}

// All these work
sum(&[1, 2, 3, 4, 5]);        // Array
sum(&vec![1, 2, 3]);          // Vec
sum(&numbers[1..3]);          // Slice of slice
sum(numbers.as_slice());      // Explicit slice
;
Ok(())
}
fn main() {}
