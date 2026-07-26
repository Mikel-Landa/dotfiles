#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use futures::stream::{FuturesUnordered, StreamExt};

// try_join!: wait for all, fail fast
let (a, b, c) = try_join!(fa, fb, fc)?;

// FuturesUnordered: process as they complete
let mut futures = FuturesUnordered::new();
futures.push(fetch_a());
futures.push(fetch_b());
futures.push(fetch_c());

while let Some(result) = futures.next().await {
    match result {
        Ok(data) => process(data),
        Err(e) => return Err(e),  // Can fail fast manually
    }
}
;
Ok(())
}
fn main() {}
