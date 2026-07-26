#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// SAFETY: MyType contains no pointers or interior mutability,
// and all bit patterns are valid MyType values.
unsafe impl Send for MyType {}
unsafe impl Sync for MyType {}
;
Ok(())
}
fn main() {}
