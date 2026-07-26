#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
#[must_use = "this `Result` may be an `Err` that should be handled"]
fn send_email(to: &str, body: &str) -> Result<(), EmailError> { ... }

send_email("user@example.com", "Hello!");  
// Warning: unused `Result` that must be used

// Mark pure functions
#[must_use = "this returns a new value and does not modify the input"]
fn compute_checksum(data: &[u8]) -> u32 { ... }

compute_checksum(&data);
// Warning: unused return value of `compute_checksum` that must be used
;
Ok(())
}
fn main() {}
