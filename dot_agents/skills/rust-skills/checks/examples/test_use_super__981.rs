#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
mod outer {
    pub fn outer_fn() -> i32 { 1 }
    
    mod inner {
        pub fn inner_fn() -> i32 { 2 }
        
        #[cfg(test)]
        mod tests {
            use super::*;           // Gets inner's items
            use super::super::*;    // Gets outer's items
            
            #[test]
            fn test_inner() {
                assert_eq!(inner_fn(), 2);
                assert_eq!(outer_fn(), 1);
            }
        }
    }
}
fn main() {}
