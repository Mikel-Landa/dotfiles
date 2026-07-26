#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn critical_types_have_expected_sizes() {
        // Document expected sizes in tests too
        assert_eq!(std::mem::size_of::<Event>(), 48);
        assert_eq!(std::mem::size_of::<Message>(), 64);
        assert_eq!(std::mem::size_of::<Header>(), 32);
    }
    
    #[test]
    fn cache_line_aligned() {
        // Verify cache-friendly sizing
        assert!(std::mem::size_of::<HotData>() <= 64);
    }
}
fn main() {}
