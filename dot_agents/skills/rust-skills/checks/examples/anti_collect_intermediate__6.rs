#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Need to iterate twice
let valid: Vec<_> = items.iter()
    .filter(|i| i.is_valid())
    .collect();
let count = valid.len();
for item in &valid {
    process(item);
}

// Need to sort (requires concrete collection)
let mut sorted: Vec<_> = items.iter()
    .filter(|i| i.is_active())
    .collect();
sorted.sort_by_key(|i| i.priority);

// Need random access
let indexed: Vec<_> = items.iter().collect();
let middle = indexed.get(indexed.len() / 2);
;
Ok(())
}
fn main() {}
