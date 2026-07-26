#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
async fn worker(mut rx: mpsc::Receiver<Task>, shutdown: CancellationToken) {
    loop {
        tokio::select! {
            _ = shutdown.cancelled() => {
                // Drain remaining messages
                while let Ok(task) = rx.try_recv() {
                    process(task).await;
                }
                break;
            }
            Some(task) = rx.recv() => {
                process(task).await;
            }
            else => break,  // Channel closed
        }
    }
}
;
Ok(())
}
fn main() {}
