#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::sync::mpsc;

let (tx, mut rx) = mpsc::channel::<Event>(100);

// Multiple producers
for i in 0..10 {
    let tx = tx.clone();  // Cheap clone
    tokio::spawn(async move {
        tx.send(Event { source: i }).await.unwrap();
    });
}

// Drop original sender so channel closes when all clones dropped
drop(tx);

// Consumer
while let Some(event) = rx.recv().await {
    process(event);
}
// Loop exits when all senders dropped
;
Ok(())
}
fn main() {}
