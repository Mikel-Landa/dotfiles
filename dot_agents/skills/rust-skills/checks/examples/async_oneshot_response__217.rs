#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Check if receiver is still waiting
let (tx, rx) = oneshot::channel::<i32>();

// In producer
if tx.is_closed() {
    println!("Receiver already gone, skip expensive computation");
} else {
    let result = expensive_computation();
    tx.send(result).ok();
}

// Async wait for close
let tx_clone = tx.clone();  // Note: can't actually clone, just showing concept
tokio::select! {
    _ = tx.closed() => println!("Receiver dropped"),
    result = compute() => { tx.send(result).ok(); }
}
;
Ok(())
}
fn main() {}
