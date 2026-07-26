#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// spawn: Runs async code on runtime threads
tokio::spawn(async {
    // Async code here
    some_async_operation().await;
});

// spawn_blocking: Runs sync code on blocking thread pool
tokio::task::spawn_blocking(|| {
    // Synchronous, possibly CPU-intensive code
    heavy_computation();
});

// spawn_blocking returns JoinHandle that can be awaited
let result = tokio::task::spawn_blocking(|| {
    expensive_sync_operation()
}).await?;
;
Ok(())
}
fn main() {}
