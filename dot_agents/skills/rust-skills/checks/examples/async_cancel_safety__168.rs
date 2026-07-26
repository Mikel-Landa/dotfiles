#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::pin::pin;
use tokio::io::AsyncReadExt;

async fn pinned_read_example<R: AsyncReadExt + Unpin>(mut reader: R) {
    let mut buf = vec![0u8; 64];
    // pin the future so it survives across select iterations
    let read_fut = pin!(reader.read_to_end(&mut buf));
    // ... use read_fut inside select! across multiple iterations
    // When the future completes it won't be cancelled mid-way
    let _ = read_fut.await;
}
;
Ok(())
}
fn main() {}
