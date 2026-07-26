#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
#[cfg(test)]
mod tests {
    use super::*;
    
    mod parsing {
        use super::*;
        
        #[test]
        fn accepts_valid_json() { ... }
        
        #[test]
        fn rejects_trailing_comma() { ... }
    }
    
    mod validation {
        use super::*;
        
        #[test]
        fn requires_name_field() { ... }
        
        #[test]
        fn email_must_contain_at_symbol() { ... }
    }
}

// Test output:
// tests::parsing::accepts_valid_json
// tests::parsing::rejects_trailing_comma
// tests::validation::requires_name_field
fn main() {}
