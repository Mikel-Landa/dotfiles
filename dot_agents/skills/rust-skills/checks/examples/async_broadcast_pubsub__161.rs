#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::sync::broadcast;

let (tx, mut rx1) = broadcast::channel::<i32>(16);
let mut rx2 = tx.subscribe();

tx.send(1)?;
tx.send(2)?;

// Both receive all messages
assert_eq!(rx1.recv().await?, 1);
assert_eq!(rx1.recv().await?, 2);
assert_eq!(rx2.recv().await?, 1);
assert_eq!(rx2.recv().await?, 2);
;
Ok(())
}
fn main() {}
