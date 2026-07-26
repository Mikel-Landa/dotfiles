#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// WARN: bind_instead_of_map
option.and_then(|x| Some(x + 1))  // Use: option.map(|x| x + 1)

// WARN: clone_on_copy
let y = x.clone();  // Where x is Copy type, just use: let y = x;

// WARN: useless_let_if_seq
let result;
if condition {
    result = 1;
} else {
    result = 2;
}
// Use: let result = if condition { 1 } else { 2 };
;
Ok(())
}
fn main() {}
