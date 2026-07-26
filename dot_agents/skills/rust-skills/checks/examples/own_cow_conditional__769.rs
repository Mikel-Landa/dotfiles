#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::borrow::Cow;

// Only allocates when needed
fn normalize_path(path: &str) -> Cow<'_, str> {
    if path.contains("//") {
        Cow::Owned(path.replace("//", "/"))  // Allocate
    } else {
        Cow::Borrowed(path)  // Zero-cost borrow
    }
}

// Static strings stay borrowed
fn format_error(code: u32) -> Cow<'static, str> {
    match code {
        404 => Cow::Borrowed("Not Found"),      // No allocation
        500 => Cow::Borrowed("Internal Error"), // No allocation
        _ => Cow::Owned(format!("Error {}", code)), // Allocate only for unknown
    }
}
;
Ok(())
}
fn main() {}
