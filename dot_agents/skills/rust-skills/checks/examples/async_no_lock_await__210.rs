#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::sync::RwLock;

async fn read_heavy(state: &RwLock<State>) {
    // Multiple readers OK, but still don't hold across await
    let value = {
        let guard = state.read().await;
        guard.value.clone()
    };
    
    // Process without lock
    let result = process(value).await;
    
    // Write lock for update
    state.write().await.result = result;
}
;
Ok(())
}
fn main() {}
