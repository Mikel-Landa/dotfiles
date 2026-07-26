#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use anyhow::{Context, Result};
use tracing::{error, instrument, warn};

// Propagate with context; do NOT log here
#[instrument]
async fn read_from_db(id: u64) -> Result<Vec<u8>> {
    inner_db_call(id)
        .await
        .with_context(|| format!("failed to read record {id} from database"))
    // No logging — just add context and propagate
}

// Also just propagates
#[instrument]
async fn fetch_data(id: u64) -> Result<Vec<u8>> {
    read_from_db(id).await.context("fetch_data failed")
}

// The handler boundary: this is where the error is HANDLED, so log it once
#[instrument]
async fn handle_request(id: u64) -> Result<(), String> {
    match fetch_data(id).await {
        Ok(data) => {
            process(data);
            Ok(())
        }
        Err(err) => {
            // {:#} on anyhow::Error prints the full cause chain
            error!(error = %format!("{err:#}"), "request failed");
            Err("internal error".to_string())
        }
    }
}

async fn inner_db_call(_id: u64) -> Result<Vec<u8>> {
    Err(anyhow::anyhow!("connection refused"))
}
fn process(_data: Vec<u8>) {}
;
Ok(())
}
fn main() {}
