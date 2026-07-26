#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tracing::info;

fn process_batch(user_id: u64, items: usize, elapsed_ms: u64) {
    // Structured: each value is a discrete, queryable field
    info!(
        user.id = user_id,
        items,
        elapsed_ms,
        "batch processed"
    );
}

#[derive(Debug)]
struct Request {
    path: String,
    method: String,
}

fn handle_request(req: &Request, status: u16) {
    // %req uses Display; ?req uses Debug; status is a primitive
    info!(
        request = ?req,   // Debug format for the whole struct
        status,
        "request complete"
    );
}
;
Ok(())
}
fn main() {}
