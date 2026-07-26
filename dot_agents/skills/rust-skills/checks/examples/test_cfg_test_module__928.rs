#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// For larger test suites, use submodules
#[cfg(test)]
mod tests {
    use super::*;
    
    mod parsing {
        use super::*;
        
        #[test]
        fn test_parse_number() { ... }
        
        #[test]
        fn test_parse_string() { ... }
    }
    
    mod validation {
        use super::*;
        
        #[test]
        fn test_validate_range() { ... }
    }
}
fn main() {}
