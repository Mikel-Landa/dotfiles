#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Separate runtimes for different workloads
struct App {
    io_runtime: Runtime,
    cpu_runtime: Runtime,
}

impl App {
    fn new() -> Self {
        Self {
            io_runtime: Builder::new_multi_thread()
                .worker_threads(8)
                .thread_name("io-worker")
                .build()
                .unwrap(),
            cpu_runtime: Builder::new_multi_thread()
                .worker_threads(4)
                .thread_name("cpu-worker")
                .build()
                .unwrap(),
        }
    }
    
    fn spawn_io<F>(&self, future: F) 
    where F: Future + Send + 'static, F::Output: Send + 'static 
    {
        self.io_runtime.spawn(future);
    }
    
    fn spawn_cpu<F>(&self, task: F) 
    where F: FnOnce() + Send + 'static 
    {
        self.cpu_runtime.spawn_blocking(task);
    }
}
;
Ok(())
}
fn main() {}
