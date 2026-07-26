#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::runtime::Builder;

// std::thread::available_parallelism() is stable since Rust 1.59
// and respects cgroup CPU quotas (unlike the unmaintained num_cpus crate)
let parallelism = std::thread::available_parallelism()
    .map(|n| n.get())
    .unwrap_or(1);

// IO-bound: more threads than cores can help
let io_runtime = Builder::new_multi_thread()
    .worker_threads(parallelism * 2)  // IO can benefit from oversubscription
    .max_blocking_threads(32)         // For spawn_blocking calls
    .enable_io()
    .enable_time()
    .build()?;

// CPU-bound: match core count
let cpu_runtime = Builder::new_multi_thread()
    .worker_threads(parallelism)      // No benefit from more than cores
    .build()?;
;
Ok(())
}
fn main() {}
