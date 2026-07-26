#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::sync::watch;

let (tx, rx) = watch::channel(vec![1, 2, 3]);

// borrow() returns Ref - must not hold across await
{
    let data = rx.borrow();
    println!("{:?}", *data);
}  // Ref dropped here

// For use across await, clone the data
let data = rx.borrow().clone();
some_async_operation().await;
use_data(&data);  // Safe

// Or use borrow_and_update() to mark as seen
let data = rx.borrow_and_update().clone();
;
Ok(())
}
fn main() {}
