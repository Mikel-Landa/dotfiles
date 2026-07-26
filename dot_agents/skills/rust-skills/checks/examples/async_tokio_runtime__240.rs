#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// Multi-threaded for concurrent IO (default)
#[tokio::main]
async fn main() {
    // Good for many concurrent network connections
    let handles: Vec<_> = urls.iter()
        .map(|url| tokio::spawn(fetch(url.clone())))
        .collect();
    
    futures::future::join_all(handles).await;
}

// Current-thread for single-threaded scenarios
#[tokio::main(flavor = "current_thread")]
async fn main() {
    // Good for single-connection clients, simpler debugging
    let client = Client::new();
    client.run().await;
}

// Custom configuration
#[tokio::main(worker_threads = 4)]
async fn main() {
    // Limit to 4 worker threads
}

// Or manual setup for more control
fn main() {
    let runtime = tokio::runtime::Builder::new_multi_thread()
        .worker_threads(4)
        .enable_all()
        .thread_name("my-worker")
        .build()
        .unwrap();
    
    runtime.block_on(async_main());
}
