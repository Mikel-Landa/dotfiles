#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize)]
pub struct Email(String);

impl<'de> Deserialize<'de> for Email {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: serde::Deserializer<'de>,
    {
        let s = String::deserialize(deserializer)?;
        Email::new(&s).map_err(serde::de::Error::custom)
    }
}

// JSON deserialization automatically validates
let email: Email = serde_json::from_str(r#""user@example.com""#)?;
;
Ok(())
}
fn main() {}
