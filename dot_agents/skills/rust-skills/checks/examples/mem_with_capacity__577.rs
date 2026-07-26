#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// From iterator length
fn collect_results(items: &[Item]) -> Vec<Output> {
    let mut results = Vec::with_capacity(items.len());
    for item in items {
        results.push(process(item));
    }
    results
}

// From filter estimate (if ~10% pass filter)
fn filter_valid(items: &[Item]) -> Vec<&Item> {
    let mut valid = Vec::with_capacity(items.len() / 10);
    for item in items {
        if item.is_valid() {
            valid.push(item);
        }
    }
    valid
}

// String from parts
fn join_with_sep(parts: &[&str], sep: &str) -> String {
    let total_len: usize = parts.iter().map(|p| p.len()).sum();
    let sep_len = if parts.is_empty() { 0 } else { sep.len() * (parts.len() - 1) };
    
    let mut result = String::with_capacity(total_len + sep_len);
    for (i, part) in parts.iter().enumerate() {
        if i > 0 {
            result.push_str(sep);
        }
        result.push_str(part);
    }
    result
}
;
Ok(())
}
fn main() {}
