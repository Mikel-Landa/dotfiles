#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
#[cfg(test)]
mod tests {
    // When you want to be explicit
    use super::{parse, ParseError, Token};
    
    // Or import all plus test utilities
    use super::*;
    use std::fs;
    use tempfile::TempDir;
    
    #[test]
    fn test_parse() { ... }
}
fn main() {}
