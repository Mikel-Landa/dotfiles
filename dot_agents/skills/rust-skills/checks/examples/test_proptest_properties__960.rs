#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use proptest::prelude::*;

#[derive(Debug, Clone)]
struct User {
    name: String,
    age: u8,
}

fn user_strategy() -> impl Strategy<Value = User> {
    ("[a-zA-Z]{1,20}", 0..120u8)
        .prop_map(|(name, age)| User { name, age })
}

proptest! {
    #[test]
    fn test_user(user in user_strategy()) {
        assert!(user.age < 150);
        assert!(!user.name.is_empty());
    }
}

// Or derive Arbitrary
use proptest_derive::Arbitrary;

#[derive(Debug, Arbitrary)]
struct Point {
    x: i32,
    y: i32,
}
;
Ok(())
}
fn main() {}
