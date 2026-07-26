#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Test serde round-trip when feature enabled
#[cfg(feature = "serde")]
#[test]
fn test_serde_roundtrip() {
    let config = Config { name: "test".into() };
    let json = serde_json::to_string(&config).unwrap();
    let parsed: Config = serde_json::from_str(&json).unwrap();
    assert_eq!(config, parsed);
}
;
Ok(())
}
fn main() {}
