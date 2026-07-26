#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Bad: boolean flags
struct Task {
    is_running: bool,
    is_completed: bool,
    is_failed: bool,
    error: Option<Error>,
}

// Good: enum state
enum TaskState {
    Pending,
    Running { started_at: Instant },
    Completed { result: Output },
    Failed { error: Error },
}

struct Task {
    state: TaskState,
}
;
Ok(())
}
fn main() {}
