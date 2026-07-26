#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Before (perf warnings)
fn process(input: &str) -> String {
    let parts: Vec<_> = input.split(",").collect();
    let mut result = String::new();
    for part in parts.iter() {
        if part.starts_with(" ") {
            result = result + &part.trim().to_string();
        }
    }
    result
}

// After (optimized)
fn process(input: &str) -> String {
    input.split(',')
        .filter(|part| part.starts_with(' '))
        .map(str::trim)
        .collect()
}
;
Ok(())
}
fn main() {}
