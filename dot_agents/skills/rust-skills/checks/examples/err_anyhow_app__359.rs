#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use anyhow::Result;

fn show_error(err: anyhow::Error) {
    // Just the top-level message
    println!("{}", err);
    // "config validation failed"
    
    // With cause chain (# alternate format)
    println!("{:#}", err);
    // "config validation failed: field 'port' must be > 0"
    
    // Debug format with backtrace
    println!("{:?}", err);
    // Full backtrace if RUST_BACKTRACE=1
    
    // Iterate through cause chain
    for cause in err.chain() {
        println!("Caused by: {}", cause);
    }
}
;
Ok(())
}
fn main() {}
