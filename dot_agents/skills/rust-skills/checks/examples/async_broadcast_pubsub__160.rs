#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::sync::broadcast;

// broadcast delivers to ALL subscribers
let (tx, _) = broadcast::channel::<Event>(100);

// Each subscriber gets ALL messages
let mut rx1 = tx.subscribe();
let mut rx2 = tx.subscribe();

tokio::spawn(async move {
    while let Ok(event) = rx1.recv().await {
        handle_in_logger(event);
    }
});

tokio::spawn(async move {
    while let Ok(event) = rx2.recv().await {
        handle_in_metrics(event);
    }
});

// Both subscribers receive this
tx.send(Event::UserLogin { user_id: 42 })?;
;
Ok(())
}
fn main() {}
