#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Bad: Multiple allocations
fn build_message(parts: &[&str]) -> String {
    let mut result = String::new();
    for part in parts {
        result = format!("{}{}\n", result, part);  // Allocates each iteration!
    }
    result
}

// Good: Pre-allocate
fn build_message(parts: &[&str]) -> String {
    let total_len: usize = parts.iter().map(|p| p.len() + 1).sum();
    let mut result = String::with_capacity(total_len);
    for part in parts {
        result.push_str(part);
        result.push('\n');
    }
    result
}

// Good: Use join
fn build_message(parts: &[&str]) -> String {
    parts.join("\n")
}
;
Ok(())
}
fn main() {}
