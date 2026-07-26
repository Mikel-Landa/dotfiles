#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// broadcast requires Clone because message is cloned to each receiver
use tokio::sync::broadcast;

#[derive(Clone)]  // Required for broadcast
struct Event {
    data: String,
}

let (tx, _) = broadcast::channel::<Event>(100);

// For non-Clone types, wrap in Arc
use std::sync::Arc;

let (tx, _) = broadcast::channel::<Arc<LargeNonClone>>(100);
;
Ok(())
}
fn main() {}
