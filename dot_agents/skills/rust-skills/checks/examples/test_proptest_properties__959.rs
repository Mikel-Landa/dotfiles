#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use proptest::prelude::*;

proptest! {
    // Any type implementing Arbitrary
    #[test]
    fn test_i32(x in any::<i32>()) { }
    
    // Regex-based string generation
    #[test]
    fn test_email(email in "[a-z]+@[a-z]+\\.[a-z]{2,3}") { }
    
    // Ranges
    #[test]
    fn test_range(x in 0..100i32) { }
    
    // Collections
    #[test]
    fn test_vec(v in prop::collection::vec(any::<i32>(), 0..10)) { }
    
    // Optionals
    #[test]
    fn test_option(opt in prop::option::of(any::<i32>())) { }
}
;
Ok(())
}
fn main() {}
