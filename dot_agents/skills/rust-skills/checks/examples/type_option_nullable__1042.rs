#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Option: value might not exist (no error context)
fn find(key: &str) -> Option<Value> { ... }

// Result: operation might fail (with error context)
fn parse(input: &str) -> Result<Value, ParseError> { ... }

// Convert Option to Result
let value = find("key").ok_or(Error::NotFound)?;

// Convert Result to Option
let value = parse("input").ok();  // Discards error
;
Ok(())
}
fn main() {}
