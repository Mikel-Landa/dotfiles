#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
use serde::{Serialize, Deserialize, Serializer, Deserializer};
use std::time::Duration;

mod duration_secs {
    use super::*;

    pub fn serialize<S>(duration: &Duration, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        serializer.serialize_u64(duration.as_secs())
    }

    pub fn deserialize<'de, D>(deserializer: D) -> Result<Duration, D::Error>
    where
        D: Deserializer<'de>,
    {
        let secs = u64::deserialize(deserializer)?;
        Ok(Duration::from_secs(secs))
    }
}

#[derive(Serialize, Deserialize, Debug)]
struct Task {
    name: String,
    // wire format: {"name":"...", "timeout": 30}
    // Rust type: Duration — no manual conversion needed at call sites
    #[serde(with = "duration_secs", rename = "timeout")]
    timeout: Duration,
}

// One-sided variants when you only need to customize one direction:
#[derive(Serialize, Deserialize, Debug)]
struct Report {
    title: String,
    #[serde(serialize_with = "duration_secs::serialize")]
    elapsed: Duration,
    // deserialize_with leaves the deserialize direction at its default
}
fn main() {}
