#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// 1. Tests - panics are expected failures
#[test]
fn test_parse() {
    let result = parse("valid").unwrap();  // OK in tests
    assert_eq!(result, expected);
}

// 2. Const/static initialization (compile-time guaranteed)
static REGEX: Lazy<Regex> = Lazy::new(|| {
    Regex::new(r"^\d+$").unwrap()  // Known-valid pattern
});

// 3. After a check that guarantees success
if map.contains_key("key") {
    let value = map.get("key").unwrap();  // Just checked
}
// Better: use if-let or entry API instead

// 4. Truly impossible cases with proof comment
let last = vec.pop().unwrap();  
// OK only if you just checked !vec.is_empty()
// Better: use last() or pattern match
;
Ok(())
}
fn main() {}
