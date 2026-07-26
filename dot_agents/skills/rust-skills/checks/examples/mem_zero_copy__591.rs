#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Bad: Copies each parsed field
struct ParsedBad {
    name: String,
    value: String,
}

fn parse_bad(input: &str) -> ParsedBad {
    let (name, value) = input.split_once('=').unwrap();
    ParsedBad {
        name: name.to_string(),   // Copy!
        value: value.to_string(), // Copy!
    }
}

// Good: References into original string
struct Parsed<'a> {
    name: &'a str,
    value: &'a str,
}

fn parse_good(input: &str) -> Parsed<'_> {
    let (name, value) = input.split_once('=').unwrap();
    Parsed { name, value }  // Zero-copy!
}
;
Ok(())
}
fn main() {}
