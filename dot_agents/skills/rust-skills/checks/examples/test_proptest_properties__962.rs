#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// If this fails with vec![100, 50, 75, 25, 0]
// Proptest will shrink to vec![1, 0] (minimal failing case)
proptest! {
    #[test]
    fn test_sorted(v in prop::collection::vec(0..1000i32, 1..100)) {
        let sorted = is_sorted(&v);
        // This will fail and shrink
    }
}
;
Ok(())
}
fn main() {}
