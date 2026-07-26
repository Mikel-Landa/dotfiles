#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// WARN: Function should not start with 'is_' returning non-bool
fn is_valid() -> i32 { 0 }  // Misleading name

// WARN: Method should not be named 'new' without returning Self
impl Foo {
    fn new() -> Bar { Bar }  // Confusing
}
;
Ok(())
}
fn main() {}
