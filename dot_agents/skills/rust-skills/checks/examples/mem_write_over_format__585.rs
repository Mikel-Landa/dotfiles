#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// One-time formatting, not in loop
let message = format!("Starting server on port {}", port);
log::info!("{}", message);

// Return value (can't return reference to local buffer)
fn describe(item: &Item) -> String {
    format!("{}: {}", item.name, item.value)  // Must allocate
}

// Debug/error paths (not hot)
if condition {
    panic!("Unexpected: {}", format!("details: {:?}", debug_info));
}
;
Ok(())
}
fn main() {}
