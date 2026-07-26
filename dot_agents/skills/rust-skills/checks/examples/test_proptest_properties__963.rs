#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
proptest! {
    #![proptest_config(ProptestConfig {
        cases: 1000,  // More test cases
        max_shrink_iters: 10000,  // More shrinking
        ..ProptestConfig::default()
    })]
    
    #[test]
    fn extensive_test(x in any::<i32>()) { }
}
fn main() {}
