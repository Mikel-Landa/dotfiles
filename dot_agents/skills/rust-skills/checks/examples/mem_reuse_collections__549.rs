#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::collections::HashMap;

fn count_words_per_line(lines: &[&str]) -> Vec<HashMap<String, usize>> {
    let mut results = Vec::with_capacity(lines.len());
    let mut counts = HashMap::new();  // Reuse across iterations
    
    for line in lines {
        counts.clear();  // Keeps bucket allocation
        
        for word in line.split_whitespace() {
            *counts.entry(word.to_string()).or_insert(0) += 1;
        }
        
        results.push(counts.clone());
    }
    
    results
}
;
Ok(())
}
fn main() {}
