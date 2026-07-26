#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Common pattern: clone for spawned task
let shared = Arc::new(SharedState::new());

for i in 0..10 {
    let shared = shared.clone();  // Clone before moving into spawn
    tokio::spawn(async move {
        // Task owns its Arc clone
        shared.do_something(i).await;
    });
}
;
Ok(())
}
fn main() {}
