#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Close errors often ignored, but document it
// INTENTIONAL: TCP close errors are not actionable
let _ = stream.shutdown(Shutdown::Both);

// Mutex poisoning recovery
// INTENTIONAL: We'll reset the state anyway
let guard = mutex.lock().unwrap_or_else(|e| e.into_inner());
;
Ok(())
}
fn main() {}
