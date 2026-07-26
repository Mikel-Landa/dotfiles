#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// unwrap: no context, hard to debug
let x = option.unwrap();

// expect: gives context, still panics
let x = option.expect("value should exist after validation");

// ?: proper error handling
let x = option.ok_or(Error::MissingValue)?;
;
Ok(())
}
fn main() {}
