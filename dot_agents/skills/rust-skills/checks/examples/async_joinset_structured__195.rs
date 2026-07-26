#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::task::JoinSet;

{
    let mut set = JoinSet::new();
    set.spawn(long_running_task());
    set.spawn(another_task());
    
    // Early exit
    return;
}  // JoinSet dropped here - all tasks are aborted!

// Explicit abort
let mut set = JoinSet::new();
set.spawn(task());
set.abort_all();  // Cancel all tasks
;
Ok(())
}
fn main() {}
