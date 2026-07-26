#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Only when implementing for external types in specific trait bounds
// This is very rare and usually indicates a design issue

// Example: you can't implement From<ExternalA> for ExternalB
// because of orphan rules. But you usually shouldn't need to.
;
Ok(())
}
fn main() {}
