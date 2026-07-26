#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::sync::broadcast::{self, error::RecvError};

let (tx, mut rx) = broadcast::channel::<Event>(16);

loop {
    match rx.recv().await {
        Ok(event) => {
            process(event);
        }
        Err(RecvError::Lagged(count)) => {
            // Receiver couldn't keep up, missed `count` messages
            log::warn!("Missed {} events", count);
            // Continue receiving new messages
        }
        Err(RecvError::Closed) => {
            break;  // All senders dropped
        }
    }
}
;
Ok(())
}
fn main() {}
