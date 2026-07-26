#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// mpsc: many producers, single consumer
let (tx, rx) = mpsc::channel::<Message>(100);
let tx2 = tx.clone();  // Can clone sender

// oneshot: single value, one producer, one consumer
let (tx, rx) = oneshot::channel::<Response>();
tx.send(response);  // Can only send once

// broadcast: multiple consumers, each gets all messages
let (tx, _) = broadcast::channel::<Event>(100);
let mut rx1 = tx.subscribe();
let mut rx2 = tx.subscribe();

// watch: single latest value, multiple consumers
let (tx, rx) = watch::channel::<State>(initial);
// Receivers see latest value, not all values
;
Ok(())
}
fn main() {}
