#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
use serde::{Serialize, Deserialize};
use serde_json;

#[derive(Serialize, Deserialize, Debug)]
#[serde(deny_unknown_fields)]
struct ServerConfig {
    host: String,
    port: u16,
    timeout_secs: u64,
}

fn parse_config(json: &str) -> Result<ServerConfig, serde_json::Error> {
    serde_json::from_str(json)
}

fn main() {
    // Typo is now a hard error
    let bad = r#"{"host":"localhost","port":8080,"timout_secs":30}"#;
    assert!(parse_config(bad).is_err());

    // Correct input still works
    let good = r#"{"host":"localhost","port":8080,"timeout_secs":30}"#;
    let cfg = parse_config(good).unwrap();
    println!("{:?}", cfg);
}
