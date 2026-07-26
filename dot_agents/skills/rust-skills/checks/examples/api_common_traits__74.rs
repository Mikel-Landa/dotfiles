#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use serde::{Serialize, Deserialize};

// For serializable types
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct ApiResponse {
    pub status: String,
    pub data: Vec<Item>,
}

// With custom serialization
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Config {
    #[serde(default)]
    pub verbose: bool,
    
    #[serde(skip_serializing_if = "Option::is_none")]
    pub api_key: Option<String>,
}
;
Ok(())
}
fn main() {}
