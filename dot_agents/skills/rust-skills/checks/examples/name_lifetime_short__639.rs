#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Standard short lifetimes
fn parse<'a>(input: &'a str) -> Result<&'a str, Error> { ... }

struct Parser<'a> {
    source: &'a str,
}

// Multiple lifetimes: 'a, 'b, 'c
fn merge<'a, 'b>(first: &'a str, second: &'b str) -> String { ... }

// Descriptive when clarity helps
fn deserialize<'de>(input: &'de [u8]) -> Result<Value<'de>, Error> { ... }
;
Ok(())
}
fn main() {}
