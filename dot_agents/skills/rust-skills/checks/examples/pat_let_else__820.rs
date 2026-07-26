#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use anyhow::{bail, Result};

fn get_id(map: &std::collections::HashMap<String, u64>, key: &str) -> Result<u64> {
    let Some(&id) = map.get(key) else {
        bail!("key '{}' not found", key);
    };
    Ok(id)
}
;
Ok(())
}
fn main() {}
