#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Mark the type itself when it should always be used
#[must_use = "futures do nothing unless polled"]
struct MyFuture<T> { ... }

// Mark RAII guards
#[must_use = "if unused, the lock will be immediately released"]
struct MutexGuard<'a, T> { ... }

// Mark results/errors
#[must_use = "errors should be handled"]
enum AppError { ... }
;
Ok(())
}
fn main() {}
