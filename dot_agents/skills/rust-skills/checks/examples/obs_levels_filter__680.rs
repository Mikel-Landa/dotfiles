#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tracing::{debug, error, info, instrument, trace, warn};

#[instrument(skip(body))]
fn handle_request(path: &str, body: &[u8]) {
    trace!("entered handler");                          // very verbose — trace
    debug!(body_len = body.len(), "parsing body");      // diagnostic — debug
    info!(path, "request received");                    // lifecycle — info

    match parse_body(body) {
        Ok(parsed) => {
            info!(items = parsed.len(), "request processed");
        }
        Err(e) if is_client_error(&e) => {
            warn!(error = ?e, "malformed request from client");   // recoverable — warn
        }
        Err(e) => {
            error!(error = ?e, "unexpected parse failure");       // needs attention — error
        }
    }
}

fn parse_body(_body: &[u8]) -> Result<Vec<u8>, String> { Ok(vec![]) }
fn is_client_error(_e: &str) -> bool { false }
;
Ok(())
}
fn main() {}
