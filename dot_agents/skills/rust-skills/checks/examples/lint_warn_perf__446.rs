#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// WARN: extend with a single element
vec.extend(std::iter::once(item));  // Use: vec.push(item)

// WARN: Inefficient to_vec
slice.iter().cloned().collect::<Vec<_>>()  // Use: slice.to_vec()

// WARN: Manual string concatenation
let s = format!("{}{}", a, b);  // When both are &str, use: a.to_owned() + b
;
Ok(())
}
fn main() {}
