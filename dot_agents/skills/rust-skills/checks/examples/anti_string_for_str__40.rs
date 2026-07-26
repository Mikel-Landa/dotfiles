#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn takes_str(s: &str) { }

let owned = String::from("hello");
takes_str(&owned);  // &String -> &str via Deref
;
Ok(())
}
fn main() {}
