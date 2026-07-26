#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Cargo.toml
[dependencies]
serde = { version = "1.0", features = ["derive"], optional = true }
rkyv = { version = "0.7", optional = true }
borsh = { version = "0.10", optional = true }

[features]
default = []
serde = ["dep:serde"]
rkyv = ["dep:rkyv"]
borsh = ["dep:borsh"]

// lib.rs
#[derive(Debug, Clone)]
#[cfg_attr(feature = "serde", derive(serde::Serialize, serde::Deserialize))]
#[cfg_attr(feature = "rkyv", derive(rkyv::Archive, rkyv::Serialize, rkyv::Deserialize))]
#[cfg_attr(feature = "borsh", derive(borsh::BorshSerialize, borsh::BorshDeserialize))]
pub struct Message {
    pub id: u64,
    pub content: String,
}
;
Ok(())
}
fn main() {}
