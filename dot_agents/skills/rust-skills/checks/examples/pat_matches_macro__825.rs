#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::assert_matches::assert_matches;

let result = parse("42");
assert_matches!(result, Ok(n) if n == 42);
;
Ok(())
}
fn main() {}
