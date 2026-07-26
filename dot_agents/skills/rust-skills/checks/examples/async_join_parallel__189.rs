#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use futures::future::join_all;

async fn fetch_all_users(ids: &[u64]) -> Vec<User> {
    let futures: Vec<_> = ids.iter()
        .map(|id| fetch_user(*id))
        .collect();
    
    join_all(futures).await
}

// With fallible futures
use futures::future::try_join_all;

async fn fetch_all_users(ids: &[u64]) -> Result<Vec<User>> {
    let futures: Vec<_> = ids.iter()
        .map(|id| fetch_user(*id))
        .collect();
    
    try_join_all(futures).await
}
;
Ok(())
}
fn main() {}
