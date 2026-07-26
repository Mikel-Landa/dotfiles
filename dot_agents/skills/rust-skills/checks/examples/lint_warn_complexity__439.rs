#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// WARN: Redundant allocation
let s = format!("literal");  // Use: "literal".to_string() or just "literal"

// WARN: Unnecessarily complicated match
match result {
    Ok(ok) => Ok(ok),
    Err(err) => Err(err),
}  // Just use: result

// WARN: Box::new in return position
fn make_error() -> Box<dyn Error> {
    Box::new(MyError)  // Could use: MyError.into()
}
;
Ok(())
}
fn main() {}
