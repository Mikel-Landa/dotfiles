#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::task::JoinSet;
use tokio_util::sync::CancellationToken;

async fn run_workers(shutdown: CancellationToken) {
    let mut set = JoinSet::new();
    
    for i in 0..4 {
        let token = shutdown.child_token();
        set.spawn(async move {
            loop {
                tokio::select! {
                    _ = token.cancelled() => break,
                    _ = do_work(i) => {}
                }
            }
        });
    }
    
    // Wait for shutdown
    shutdown.cancelled().await;
    
    // Abort remaining tasks
    set.abort_all();
    
    // Wait for all to finish (drain aborted tasks)
    while set.join_next().await.is_some() {}
}
;
Ok(())
}
fn main() {}
