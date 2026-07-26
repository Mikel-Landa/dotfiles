#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::sync::mpsc;
use tokio::time::{timeout, Duration};

let (tx, mut rx) = mpsc::channel::<Message>(100);

// Option 1: Wait indefinitely (default)
tx.send(msg).await?;

// Option 2: Try send, fail if full
match tx.try_send(msg) {
    Ok(()) => println!("Sent"),
    Err(TrySendError::Full(msg)) => {
        println!("Channel full, dropping message");
    }
    Err(TrySendError::Closed(msg)) => {
        println!("Receiver dropped");
    }
}

// Option 3: Timeout
match timeout(Duration::from_secs(1), tx.send(msg)).await {
    Ok(Ok(())) => println!("Sent"),
    Ok(Err(_)) => println!("Channel closed"),
    Err(_) => println!("Timeout - channel full for too long"),
}

// Option 4: send with permit reservation
let permit = tx.reserve().await?;
permit.send(msg);  // Guaranteed to succeed
;
Ok(())
}
fn main() {}
