#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// In your library crate - typed errors
use thiserror::Error;

#[derive(Error, Debug)]
pub enum ApiError {
    #[error("rate limited")]
    RateLimited,
    #[error("not found: {0}")]
    NotFound(String),
}

// In your application - anyhow for handling
use anyhow::{Context, Result};

fn fetch_user(id: u64) -> Result<User> {
    api::get_user(id)
        .with_context(|| format!("failed to fetch user {}", id))
}

// Can still downcast if needed
fn handle_error(err: anyhow::Error) {
    if let Some(api_err) = err.downcast_ref::<ApiError>() {
        match api_err {
            ApiError::RateLimited => wait_and_retry(),
            ApiError::NotFound(id) => log_missing(id),
        }
    }
}
;
Ok(())
}
fn main() {}
