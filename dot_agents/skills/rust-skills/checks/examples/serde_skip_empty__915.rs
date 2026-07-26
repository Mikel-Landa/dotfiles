#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Debug)]
struct ApiResponse {
    id: u64,
    name: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    description: Option<String>,
    #[serde(skip_serializing_if = "Vec::is_empty")]
    tags: Vec<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    error: Option<String>,
    // internal field excluded entirely from the wire format
    #[serde(skip)]
    _cache_key: Option<String>,
}

impl Default for ApiResponse {
    fn default() -> Self {
        ApiResponse {
            id: 0,
            name: String::new(),
            description: None,
            tags: Vec::new(),
            error: None,
            _cache_key: None,
        }
    }
}
;
Ok(())
}
fn main() {}
