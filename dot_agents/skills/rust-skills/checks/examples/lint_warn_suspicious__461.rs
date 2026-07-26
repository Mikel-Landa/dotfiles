#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Caught: Suspicious double negation
let value = --x;  // In Rust, this is -(-x), not pre-decrement

// Caught: Suspicious modulo
let remainder = x % 1;  // Always 0 for integers

// Caught: Suspicious else formatting
if condition {
    do_something();
}
else {  // Weird formatting, might be a mistake
    do_other();
}
;
Ok(())
}
fn main() {}
