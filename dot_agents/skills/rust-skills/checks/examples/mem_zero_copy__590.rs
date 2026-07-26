#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn method_to_cow(method: &http::Method) -> Cow<'static, str> {
    match *method {
        Method::GET => Cow::Borrowed("GET"),      // Zero-copy
        Method::POST => Cow::Borrowed("POST"),    // Zero-copy
        Method::PUT => Cow::Borrowed("PUT"),      // Zero-copy
        _ => Cow::Owned(method.to_string()),      // Only copies for rare methods
    }
}
;
Ok(())
}
fn main() {}
