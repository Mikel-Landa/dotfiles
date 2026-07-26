#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
proptest! {
    #[test]
    fn parse_roundtrip(config in valid_config_strategy()) {
        let serialized = config.to_string();
        let parsed = Config::parse(&serialized).unwrap();
        assert_eq!(config, parsed);
    }
}
;
Ok(())
}
fn main() {}
