#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
use std::fmt;

#[derive(Debug)] // derive Debug for free diagnostic output
struct ParseError {
    input: String,
    line: u32,
}

// Hand-write Display for a clean, human-readable message
impl fmt::Display for ParseError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "parse error on line {}: {:?}", self.line, self.input)
    }
}

impl std::error::Error for ParseError {}

fn main() {
    let e = ParseError { input: "foo bar".into(), line: 42 };

    // User-facing: clean sentence
    eprintln!("error: {e}");

    // Developer/log: structured dump
    eprintln!("debug: {e:?}");
}
