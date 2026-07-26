#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Be specific
enum Error {
    NotFound,           // Good: specific
    PermissionDenied,   // Good: specific
    Error,              // Bad: vague
}

// Avoid redundant type name in variant
enum ConnectionState {
    Connected,          // Good
    Disconnected,       // Good
    ConnectionError,    // Bad: redundant "Connection"
}

// Use None/Some pattern for Option-like enums
enum MaybeValue<T> {
    Some(T),
    None,
}
;
Ok(())
}
fn main() {}
