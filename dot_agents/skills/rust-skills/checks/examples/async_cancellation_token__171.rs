#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio_util::sync::CancellationToken;

// Create token
let token = CancellationToken::new();

// Clone for sharing (cheap Arc-based clone)
let token2 = token.clone();

// Check if cancelled (non-blocking)
if token.is_cancelled() {
    return;
}

// Wait for cancellation (async)
token.cancelled().await;

// Trigger cancellation
token.cancel();

// Child tokens - cancelled when parent is cancelled
let child = token.child_token();
;
Ok(())
}
fn main() {}
