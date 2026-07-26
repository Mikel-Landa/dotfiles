#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::task::JoinSet;

async fn worker_pool(mut rx: mpsc::Receiver<Task>) {
    let mut set = JoinSet::new();
    let max_concurrent = 10;
    
    loop {
        tokio::select! {
            // Accept new tasks if under limit
            Some(task) = rx.recv(), if set.len() < max_concurrent => {
                set.spawn(process_task(task));
            }
            
            // Process completed tasks
            Some(result) = set.join_next() => {
                handle_result(result);
            }
            
            // Exit when no tasks and channel closed
            else => break,
        }
    }
}
;
Ok(())
}
fn main() {}
