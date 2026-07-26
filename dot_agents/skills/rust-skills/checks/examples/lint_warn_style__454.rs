#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Before (style warnings)
fn process(data: Vec<i32>) -> Option<i32> {
    if data.len() == 0 {
        return None;
    }
    let first = match data.first() {
        Some(x) => x,
        None => return None,
    };
    return Some(*first);
}

// After (idiomatic)
fn process(data: Vec<i32>) -> Option<i32> {
    if data.is_empty() {
        return None;
    }
    let first = data.first()?;
    Some(*first)
}
;
Ok(())
}
fn main() {}
