#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Task A:
let guard = mutex.lock().await;    // Acquires lock
expensive_io().await;              // Suspended, still holding lock!
// ... many milliseconds pass ...
drop(guard);                       // Finally releases

// Task B, C, D:
let guard = mutex.lock().await;    // All blocked waiting for A!
;
Ok(())
}
fn main() {}
