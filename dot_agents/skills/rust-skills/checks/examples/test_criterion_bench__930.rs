#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// BAD: Compiler may optimize away the computation
b.iter(|| fibonacci(20));  // Result unused, might be eliminated

// GOOD: black_box prevents optimization
b.iter(|| fibonacci(black_box(20)));

// Also wrap the result if needed
b.iter(|| black_box(fibonacci(black_box(20))));
;
Ok(())
}
fn main() {}
