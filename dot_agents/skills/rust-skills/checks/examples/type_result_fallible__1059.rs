#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn process_file(path: &str) -> Result<ProcessedData, Error> {
    let content = std::fs::read_to_string(path)?;  // Propagates Err
    let parsed: RawData = serde_json::from_str(&content)?;
    let validated = validate(parsed)?;
    let processed = transform(validated)?;
    Ok(processed)
}

// Equivalent to:
fn process_file(path: &str) -> Result<ProcessedData, Error> {
    let content = match std::fs::read_to_string(path) {
        Ok(c) => c,
        Err(e) => return Err(e.into()),
    };
    // ... etc
}
;
Ok(())
}
fn main() {}
