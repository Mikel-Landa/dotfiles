#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
#[test]
#[should_panic]
fn divide_by_zero_panics() {
    divide(1, 0);  // Test passes when this panics
}

// With expected message
#[test]
#[should_panic(expected = "division by zero")]
fn divide_by_zero_panics_with_message() {
    divide(1, 0);  // Panics with "division by zero"
}

// Partial message match
#[test]
#[should_panic(expected = "index out of bounds")]
fn index_panic_contains_message() {
    let v = vec![1, 2, 3];
    let _ = v[100];  // Message contains "index out of bounds"
}
;
Ok(())
}
fn main() {}
