#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn get_config_value(key: &str) -> String {
    CONFIG.get(key)
        .expect(&format!("missing required config: {}", key))
        .to_string()
}

#[test]
#[should_panic(expected = "missing required config: DATABASE_URL")]
fn missing_config_panics_with_key() {
    get_config_value("DATABASE_URL");
}
;
Ok(())
}
fn main() {}
