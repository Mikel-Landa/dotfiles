#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::sync::Mutex;

async fn good_update(state: &Mutex<State>) {
    // Fetch data BEFORE taking the lock
    let data = fetch_from_network().await;
    
    // Lock only for the quick update
    let mut guard = state.lock().await;
    guard.value = data;
}  // Lock released immediately

// Alternative: Clone data out, process, then update
async fn good_update_v2(state: &Mutex<State>) {
    // Extract what we need
    let id = {
        let guard = state.lock().await;
        guard.id.clone()
    };  // Lock released!
    
    // Do async work without lock
    let data = fetch_by_id(id).await;
    
    // Quick update
    state.lock().await.value = data;
}
;
Ok(())
}
fn main() {}
