#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// WARN: Redundant clone on Copy type
let x = 5;
let y = x.clone();  // Just use: let y = x;

// WARN: Redundant closure
iter.map(|x| foo(x))  // Just use: iter.map(foo)

// WARN: Redundant pattern matching
match result {
    Ok(x) => Ok(x),
    Err(e) => Err(e),
}  // Just return result
;
Ok(())
}
fn main() {}
