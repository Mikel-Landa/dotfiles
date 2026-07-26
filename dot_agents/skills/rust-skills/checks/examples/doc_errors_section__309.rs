#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
/// Sends an HTTP request and returns the response.
///
/// # Errors
///
/// | Error | Condition |
/// |-------|-----------|
/// | [`HttpError::Timeout`] | Request exceeded timeout duration |
/// | [`HttpError::InvalidUrl`] | URL could not be parsed |
/// | [`HttpError::ConnectionRefused`] | Server refused connection |
/// | [`HttpError::TlsError`] | TLS handshake failed |
pub fn send(request: Request) -> Result<Response, HttpError> {
    // ...
}
;
Ok(())
}
fn main() {}
