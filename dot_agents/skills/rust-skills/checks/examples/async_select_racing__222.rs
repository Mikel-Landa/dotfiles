#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
async fn select_example() {
    select! {
        _ = operation_a() => {
            println!("A completed first");
            // operation_b() is dropped/cancelled
        }
        _ = operation_b() => {
            println!("B completed first");
            // operation_a() is dropped/cancelled
        }
    }
}

// Futures are cancelled at their next .await point
// For immediate cancellation, futures must be cancel-safe
;
Ok(())
}
fn main() {}
