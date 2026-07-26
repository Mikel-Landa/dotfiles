#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// BAD: Using panic for control flow
fn find_or_die(items: &[Item], id: u64) -> &Item {
    items.iter()
        .find(|i| i.id == id)
        .unwrap_or_else(|| panic!("item {} not found", id))
}

// GOOD: Return Option or Result
fn find(items: &[Item], id: u64) -> Option<&Item> {
    items.iter().find(|i| i.id == id)
}
;
Ok(())
}
fn main() {}
