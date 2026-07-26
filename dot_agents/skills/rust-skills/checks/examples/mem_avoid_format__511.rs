#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Return &'static str for constants
fn get_error_message() -> &'static str {
    "An error occurred"  // No allocation
}

// Use format args directly
for item in items {
    log::info!("Processing item: {}", item);  // No intermediate String
}

// Return Cow for mixed static/dynamic
use std::borrow::Cow;

fn classify(n: i32) -> Cow<'static, str> {
    if n > 0 {
        Cow::Borrowed("positive")  // No allocation
    } else if n < 0 {
        Cow::Borrowed("negative")  // No allocation
    } else {
        Cow::Borrowed("zero")      // No allocation
    }
}

// Or just &'static str if always static
fn classify_str(n: i32) -> &'static str {
    if n > 0 { "positive" }
    else if n < 0 { "negative" }
    else { "zero" }
}
;
Ok(())
}
fn main() {}
