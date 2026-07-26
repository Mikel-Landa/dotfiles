#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// ID types
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct EntityId(u64);

// Value types
#[derive(Debug, Clone, Copy, PartialEq, Default)]
pub struct Vector2 { x: f32, y: f32 }

// Configuration
#[derive(Debug, Clone, PartialEq, Default)]
pub struct Config {
    name: String,
    options: HashMap<String, String>,
}

// Error types
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ParseError {
    InvalidSyntax(String),
    UnexpectedToken(Token),
}
;
Ok(())
}
fn main() {}
