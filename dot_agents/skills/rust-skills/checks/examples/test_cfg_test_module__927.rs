#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
#[cfg(test)]
mod tests {
    use super::*;
    
    // Test-only helpers
    fn create_test_data() -> Data {
        Data {
            id: 1,
            name: "test".into(),
            values: vec![1, 2, 3],
        }
    }
    
    fn assert_valid(data: &Data) {
        assert!(data.id > 0);
        assert!(!data.name.is_empty());
    }
    
    #[test]
    fn test_processing() {
        let data = create_test_data();
        let result = process(&data);
        assert_valid(&result);
    }
}
fn main() {}
