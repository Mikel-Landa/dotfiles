#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::sync::watch;

let (tx, mut rx) = watch::channel("initial");

// Immediate read - no waiting
assert_eq!(*rx.borrow(), "initial");

// Wait for change
tx.send("updated")?;
rx.changed().await?;
assert_eq!(*rx.borrow(), "updated");

// Multiple rapid updates - receiver sees latest
tx.send("v1")?;
tx.send("v2")?;
tx.send("v3")?;
rx.changed().await?;
assert_eq!(*rx.borrow(), "v3");  // Skipped v1, v2
;
Ok(())
}
fn main() {}
