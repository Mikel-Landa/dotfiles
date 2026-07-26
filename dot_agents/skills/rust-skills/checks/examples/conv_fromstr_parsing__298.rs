#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
use std::str::FromStr;
use std::fmt;

#[derive(Debug, PartialEq)]
enum Color { Red, Green, Blue }

#[derive(Debug)]
struct ParseColorError(String);

impl fmt::Display for ParseColorError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "unknown color: {}", self.0)
    }
}

impl std::error::Error for ParseColorError {}

impl FromStr for Color {
    type Err = ParseColorError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "red"   => Ok(Color::Red),
            "green" => Ok(Color::Green),
            "blue"  => Ok(Color::Blue),
            other   => Err(ParseColorError(other.to_owned())),
        }
    }
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Standard idiom — works with clap, config parsers, etc.
    let c: Color = "green".parse()?;
    assert_eq!(c, Color::Green);
    Ok(())
}
