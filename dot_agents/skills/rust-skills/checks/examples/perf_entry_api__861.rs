#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn group_by_category(items: Vec<Item>) -> HashMap<Category, Vec<Item>> {
    let mut groups: HashMap<Category, Vec<Item>> = HashMap::new();
    for item in items {
        groups.entry(item.category.clone())
            .or_default()
            .push(item);
    }
    groups
}
;
Ok(())
}
fn main() {}
