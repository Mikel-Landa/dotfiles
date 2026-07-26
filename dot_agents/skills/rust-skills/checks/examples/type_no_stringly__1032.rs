#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Status as enum - compile-time safety
enum Status {
    Pending,
    Active,
    Completed,
}

fn set_status(status: Status) {
    match status {
        Status::Pending => { ... }
        Status::Active => { ... }
        Status::Completed => { ... }
    }  // Exhaustive - compiler checks all cases
}

// Can only pass valid values
set_status(Status::Pending);  // OK
set_status(Status::Aktivev);  // Compile error - typo caught!

// Configuration with typed builder
struct Config {
    timeout: Duration,
    retries: u32,
    mode: Mode,
}

enum Mode { Fast, Safe, Balanced }
;
Ok(())
}
fn main() {}
