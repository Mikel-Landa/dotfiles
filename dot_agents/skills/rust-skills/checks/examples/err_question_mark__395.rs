#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// This:
let x = expr?;

// Expands roughly to:
let x = match expr {
    Ok(val) => val,
    Err(err) => return Err(From::from(err)),
};
;
Ok(())
}
fn main() {}
