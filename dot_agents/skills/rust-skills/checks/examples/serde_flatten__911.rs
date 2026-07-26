#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use serde::{Serialize, Deserialize};
use std::collections::HashMap;

#[derive(Serialize, Deserialize, Debug)]
struct Pagination {
    page: u32,
    per_page: u32,
    total: u64,
}

#[derive(Serialize, Deserialize, Debug)]
struct UserListResponse {
    users: Vec<String>,
    #[serde(flatten)]
    pagination: Pagination,
}

#[derive(Serialize, Deserialize, Debug)]
struct PostListResponse {
    posts: Vec<String>,
    #[serde(flatten)]
    pagination: Pagination,
}

// Capture unknown/dynamic keys into a map
#[derive(Serialize, Deserialize, Debug)]
struct FlexibleConfig {
    name: String,
    version: u32,
    #[serde(flatten)]
    extra: HashMap<String, serde_json::Value>,
}
;
Ok(())
}
fn main() {}
