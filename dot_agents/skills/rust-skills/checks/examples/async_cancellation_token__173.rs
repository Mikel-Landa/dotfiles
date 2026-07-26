#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
use tokio::signal;

async fn main() -> Result<()> {
    let shutdown = CancellationToken::new();
    
    // Spawn signal handler
    let shutdown_trigger = shutdown.clone();
    tokio::spawn(async move {
        signal::ctrl_c().await.expect("failed to listen for Ctrl+C");
        println!("Received Ctrl+C, initiating shutdown...");
        shutdown_trigger.cancel();
    });
    
    // Run application with shutdown token
    run_app(shutdown).await
}

async fn run_app(shutdown: CancellationToken) -> Result<()> {
    let mut tasks = JoinSet::new();
    
    tasks.spawn(worker_task(shutdown.child_token()));
    tasks.spawn(server_task(shutdown.child_token()));
    
    // Wait for shutdown or task completion
    tokio::select! {
        _ = shutdown.cancelled() => {
            println!("Shutdown requested, waiting for tasks...");
        }
        Some(result) = tasks.join_next() => {
            // A task completed/failed
            result??;
        }
    }
    
    // Wait for remaining tasks with timeout
    tokio::time::timeout(
        Duration::from_secs(30),
        async { while tasks.join_next().await.is_some() {} }
    ).await.ok();
    
    Ok(())
}
