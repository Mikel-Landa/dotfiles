#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// src/my_module.rs

fn public_api() -> i32 {
    private_helper() * 2
}

fn private_helper() -> i32 {
    21
}

#[cfg(test)]
mod tests {
    use super::*;  // Access to private items
    
    #[test]
    fn test_public_api() {
        assert_eq!(public_api(), 42);
    }
    
    #[test]
    fn test_private_helper() {
        assert_eq!(private_helper(), 21);  // Can test private!
    }
}
fn main() {}
