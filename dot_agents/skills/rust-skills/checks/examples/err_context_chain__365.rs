#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
fn main() {
    if let Err(e) = run() {
        // Just top-level message
        eprintln!("Error: {}", e);
        
        // Full chain with alternate format
        eprintln!("Error: {:#}", e);
        
        // Debug format (includes backtrace if enabled)
        eprintln!("Error: {:?}", e);
        
        // Iterate through chain
        for (i, cause) in e.chain().enumerate() {
            eprintln!("  {}: {}", i, cause);
        }
    }
}
