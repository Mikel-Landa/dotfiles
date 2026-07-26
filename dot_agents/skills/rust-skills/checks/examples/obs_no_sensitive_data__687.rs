#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tracing::{info, instrument};

// A simple redacting newtype — implement for any sensitive type
#[derive(Clone)]
struct Secret(String);

impl std::fmt::Debug for Secret {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str("[redacted]")
    }
}

impl std::fmt::Display for Secret {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str("[redacted]")
    }
}

struct Credentials {
    username: String,
    password: Secret,   // redacts in Debug/Display
    api_key: Secret,    // redacts in Debug/Display
}

// GOOD: skip sensitive args by name
#[instrument(skip(credentials), fields(username = %credentials.username))]
async fn authenticate(credentials: &Credentials) -> bool {
    info!("authenticating user");
    // password and api_key never appear in any span field or log line
    verify_password(&credentials.username, &credentials.password)
}

fn verify_password(_username: &str, _password: &Secret) -> bool { true }
;
Ok(())
}
fn main() {}
