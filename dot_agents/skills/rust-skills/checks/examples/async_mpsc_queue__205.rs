#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Reserve slot before preparing message
let permit = tx.reserve().await?;

// Now we have guaranteed capacity
let message = expensive_to_create_message();
permit.send(message);  // Never fails

// Useful when message creation is expensive
// and you don't want to create it if channel is full
;
Ok(())
}
fn main() {}
