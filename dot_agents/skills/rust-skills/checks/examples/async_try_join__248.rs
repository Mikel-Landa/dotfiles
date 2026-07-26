#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::time::{timeout, Duration};

async fn fetch_with_timeout() -> Result<(A, B)> {
    timeout(
        Duration::from_secs(10),
        try_join!(fetch_a(), fetch_b())
    )
    .await
    .map_err(|_| Error::Timeout)?
}

// Per-operation timeout
async fn individual_timeouts() -> Result<(A, B)> {
    try_join!(
        timeout(Duration::from_secs(5), fetch_a())
            .map_err(|_| Error::Timeout)
            .and_then(|r| async { r }),
        timeout(Duration::from_secs(5), fetch_b())
            .map_err(|_| Error::Timeout)
            .and_then(|r| async { r }),
    )
}
;
Ok(())
}
fn main() {}
