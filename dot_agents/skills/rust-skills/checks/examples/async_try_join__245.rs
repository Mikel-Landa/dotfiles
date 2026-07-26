#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::try_join;

async fn fetch_all() -> Result<(A, B, C)> {
    // Concurrent AND fail-fast
    let (a, b, c) = try_join!(
        fetch_a(),
        fetch_b(),
        fetch_c(),
    )?;
    
    Ok((a, b, c))
}

// For dynamic collections
use futures::future::try_join_all;

async fn fetch_users(ids: &[u64]) -> Result<Vec<User>> {
    let futures: Vec<_> = ids.iter()
        .map(|id| fetch_user(*id))
        .collect();
    
    try_join_all(futures).await
}
;
Ok(())
}
fn main() {}
