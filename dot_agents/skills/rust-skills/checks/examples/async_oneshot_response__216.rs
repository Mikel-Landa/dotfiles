#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::sync::oneshot;

let (tx, rx) = oneshot::channel::<String>();

// Sender dropped without sending
drop(tx);
match rx.await {
    Ok(value) => println!("Got: {}", value),
    Err(oneshot::error::RecvError { .. }) => {
        println!("Sender dropped");
    }
}

// Receiver dropped before send
let (tx, rx) = oneshot::channel::<String>();
drop(rx);
match tx.send("hello".to_string()) {
    Ok(()) => println!("Sent"),
    Err(value) => println!("Receiver dropped, value: {}", value),
}
;
Ok(())
}
fn main() {}
