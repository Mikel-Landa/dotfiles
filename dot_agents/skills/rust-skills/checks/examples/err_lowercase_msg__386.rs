#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use anyhow::{Context, Result};

fn load_user(id: u64) -> Result<User> {
    let data = fetch(id)
        .with_context(|| format!("failed to fetch user {}", id))?;
    
    parse_user(data)
        .with_context(|| "failed to parse user data")?
}

// Output: "failed to fetch user 42: connection refused"
// All lowercase, clean chain
;
Ok(())
}
fn main() {}
