#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Prefer std::sync::Mutex for work that does NOT span an .await —
// it is simpler, faster, and avoids the async overhead.
// Only reach for tokio::sync::Mutex when you genuinely must hold
// the lock across an .await point (rare; usually a sign to redesign).

// std::sync::Mutex in async (quick, non-awaiting operation — preferred):
async fn quick_update(state: &std::sync::Mutex<State>) {
    state.lock().unwrap().counter += 1;  // No await inside lock scope, OK
}

// tokio::sync::Mutex (only when the lock scope must span an .await):
async fn must_await_inside(state: &tokio::sync::Mutex<State>) {
    let mut guard = state.lock().await;
    // Only justified if you truly need the lock held across an async op
    // (usually you don't — extract data first, then release the lock)
}
;
Ok(())
}
fn main() {}
