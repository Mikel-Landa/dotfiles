#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::time::Duration;

// Simple case: derive uses each field type's Default (Duration::ZERO, 0, false)
#[derive(Default)]
struct Config {
    timeout: Duration,
    retries: u32,
    verbose: bool,
}
;
Ok(())
}
fn main() {}
