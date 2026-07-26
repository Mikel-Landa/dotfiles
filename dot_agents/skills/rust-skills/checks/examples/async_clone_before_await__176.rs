#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::sync::Arc;

async fn process(data: Arc<Data>) {
    // Clone what you need before await
    let items = data.items.clone();  // Owned Vec
    
    expensive_async_operation().await;
    
    use_items(&items);  // Using owned data
}

// Or clone the Arc itself
async fn share_data(data: Arc<Data>) {
    let data = data.clone();  // Another Arc handle
    
    some_async_work().await;
    
    process(&data);  // Safe - we own the Arc
}
;
Ok(())
}
fn main() {}
