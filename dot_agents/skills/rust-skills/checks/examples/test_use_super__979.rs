#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// src/my_module.rs
pub struct PublicStruct { ... }
struct PrivateStruct { ... }  // Private

pub fn public_function() -> i32 { ... }
fn private_helper() -> i32 { ... }  // Private

#[cfg(test)]
mod tests {
    use super::*;  // Imports everything from parent
    
    #[test]
    fn test_public_struct() {
        let s = PublicStruct::new();
        // ...
    }
    
    #[test]
    fn test_private_struct() {
        let s = PrivateStruct::new();  // Can access private!
        // ...
    }
    
    #[test]
    fn test_private_helper() {
        assert_eq!(private_helper(), 42);  // Can test private!
    }
}
fn main() {}
