#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio_util::sync::CancellationToken;

// Auto-cancel on drop
let token = CancellationToken::new();
let guard = token.clone().drop_guard();

tokio::spawn({
    let token = token.clone();
    async move {
        token.cancelled().await;
        println!("Cancelled!");
    }
});

drop(guard);  // Automatically calls token.cancel()
;
Ok(())
}
fn main() {}
