#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::collections::HashMap;

fn process_and_clear(map: &mut HashMap<String, Value>) {
    // Process all entries, clearing the map
    for (key, value) in map.drain() {
        process(key, value);
    }
    // map is now empty but keeps capacity
}
;
Ok(())
}
fn main() {}
