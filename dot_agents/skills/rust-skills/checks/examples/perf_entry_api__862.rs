#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
match map.entry(key) {
    Entry::Occupied(mut entry) => {
        let value = entry.get_mut();
        if should_update(value) {
            *value = new_value;
        }
    }
    Entry::Vacant(entry) => {
        entry.insert(default_value);
    }
}
;
Ok(())
}
fn main() {}
