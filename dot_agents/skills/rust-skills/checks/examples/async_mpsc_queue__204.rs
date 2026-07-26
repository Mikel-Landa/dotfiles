#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::sync::mpsc;

let (tx, mut rx) = mpsc::channel::<Message>(100);
let weak = tx.downgrade();  // Doesn't keep channel alive

tokio::spawn(async move {
    // Strong sender - keeps channel alive
    tx.send("from strong".into()).await.unwrap();
});

tokio::spawn(async move {
    // Weak sender - may fail if strong senders dropped
    if let Some(tx) = weak.upgrade() {
        tx.send("from weak".into()).await.unwrap();
    }
});
;
Ok(())
}
fn main() {}
