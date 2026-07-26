#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Return iterator, let caller collect if needed
fn valid_items(items: &[Item]) -> impl Iterator<Item = &Item> {
    items.iter().filter(|i| i.is_valid())
}

// Caller decides
let count = valid_items(&items).count();  // No collection
let vec: Vec<_> = valid_items(&items).collect();  // Collection when needed
;
Ok(())
}
fn main() {}
