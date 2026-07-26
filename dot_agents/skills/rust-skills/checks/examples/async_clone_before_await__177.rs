#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Futures must be Send to spawn on multi-threaded runtime
async fn not_send() {
    let rc = Rc::new(42);  // Rc is !Send
    
    tokio::time::sleep(Duration::from_secs(1)).await;
    
    println!("{}", rc);  // rc held across await
}

tokio::spawn(not_send());  // ERROR: future is not Send

// Fix: use Arc or don't hold across await
async fn is_send() {
    let arc = Arc::new(42);  // Arc is Send
    
    tokio::time::sleep(Duration::from_secs(1)).await;
    
    println!("{}", arc);
}

tokio::spawn(is_send());  // OK
;
Ok(())
}
fn main() {}
