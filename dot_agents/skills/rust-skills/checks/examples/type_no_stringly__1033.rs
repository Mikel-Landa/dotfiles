#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::str::FromStr;

#[derive(Debug, Clone, Copy)]
enum Priority {
    Low,
    Medium,
    High,
}

impl FromStr for Priority {
    type Err = ParseError;
    
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s.to_lowercase().as_str() {
            "low" => Ok(Priority::Low),
            "medium" | "med" => Ok(Priority::Medium),
            "high" => Ok(Priority::High),
            _ => Err(ParseError::UnknownPriority(s.to_string())),
        }
    }
}

// Parse once at boundary
fn handle_request(priority_str: &str) -> Result<(), Error> {
    let priority: Priority = priority_str.parse()?;
    // From here, priority is type-safe
    process(priority);
    Ok(())
}
;
Ok(())
}
fn main() {}
