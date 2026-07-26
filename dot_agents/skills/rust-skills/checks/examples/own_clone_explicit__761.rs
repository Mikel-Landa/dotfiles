#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
let mut buffer = String::with_capacity(1000);

// Bad: drops old allocation, creates new one
buffer = source.clone();

// Good: reuses existing capacity if sufficient
buffer.clone_from(&source);
;
Ok(())
}
fn main() {}
