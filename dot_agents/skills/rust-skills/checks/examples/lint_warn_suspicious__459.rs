#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// WARN: Suspicious map usage
let _: Vec<_> = vec.iter().map(|x| { 
    println!("{}", x);  // Side effect in map
    x
}).collect();  // Use for_each instead

// WARN: Suspicious string formatting
let s = format!("{}", format!("{}", x));  // Redundant nested format
;
Ok(())
}
fn main() {}
