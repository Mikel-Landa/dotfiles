#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// WARN: Overly complex boolean expression
if !(x == 0) { }  // Use: if x != 0 { }

// WARN: Manual implementation of Option::map
match option {
    Some(x) => Some(x + 1),
    None => None,
}  // Use: option.map(|x| x + 1)

// WARN: Unnecessary filter before count
iter.filter(|x| predicate(x)).count()  // Could simplify if only counting
;
Ok(())
}
fn main() {}
