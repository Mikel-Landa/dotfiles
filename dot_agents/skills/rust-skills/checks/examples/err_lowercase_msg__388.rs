#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Proper nouns / acronyms keep their case
#[error("invalid JSON syntax")]     // JSON is an acronym
#[error("OAuth token expired")]     // OAuth is a proper noun
#[error("HTTP request failed")]     // HTTP is an acronym

// Error codes can be uppercase
#[error("error code E0001: invalid input")]
;
Ok(())
}
fn main() {}
