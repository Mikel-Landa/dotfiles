#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Result and Option are #[must_use]
let v: Vec<i32> = vec![1, 2, 3];
v.first();  // Warning: unused Option

// Iterator adapters are #[must_use]
v.iter().map(|x| x * 2);  // Warning: iterators are lazy

// String methods that return new values
let s = "hello";
s.to_uppercase();  // Warning: unused String
;
Ok(())
}
fn main() {}
