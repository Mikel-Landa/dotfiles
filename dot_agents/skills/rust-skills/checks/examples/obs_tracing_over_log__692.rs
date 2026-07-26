#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
use tracing::info;

fn handle_login(id: u64) {
    // Structured field: user.id is queryable in JSON/OpenTelemetry backends
    info!(user.id = %id, "user logged in");
}

fn main() {
    // One-time subscriber init belongs in the binary, not in libraries
    tracing_subscriber::fmt::init();
    handle_login(42);
}
