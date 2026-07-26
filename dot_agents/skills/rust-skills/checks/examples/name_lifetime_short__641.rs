#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use serde::{Deserialize, Serialize};

// 'de is the standard serde lifetime for borrowed data
#[derive(Deserialize)]
struct Request<'de> {
    #[serde(borrow)]
    name: &'de str,
    #[serde(borrow)]
    tags: Vec<&'de str>,
}
;
Ok(())
}
fn main() {}
