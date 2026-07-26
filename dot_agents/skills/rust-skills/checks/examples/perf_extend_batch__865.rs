#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn merge_all(chunks: Vec<Vec<Item>>) -> Vec<Item> {
    // Calculate total size
    let total: usize = chunks.iter().map(|c| c.len()).sum();
    
    let mut result = Vec::with_capacity(total);
    for chunk in chunks {
        result.extend(chunk);
    }
    result
}
;
Ok(())
}
fn main() {}
