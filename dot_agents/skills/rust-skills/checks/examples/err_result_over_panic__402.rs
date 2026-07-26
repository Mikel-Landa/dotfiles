#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// 1. Bug in the program (invariant violation)
fn get_cached_value(&self, key: &str) -> &Value {
    self.cache.get(key).expect("BUG: key was verified to exist")
}

// 2. Setup/initialization that can't reasonably fail
fn main() {
    let config = Config::load().expect("Failed to load required config");
    // Can't run without config, panic is reasonable
}

// 3. Tests
#[test]
fn test_parse() {
    let result = parse("valid input").unwrap(); // unwrap OK in tests
    assert_eq!(result, expected);
}

// 4. Examples and prototypes
fn main() {
    // Quick prototype, panic is fine
    let data = fetch_data().unwrap();
}
