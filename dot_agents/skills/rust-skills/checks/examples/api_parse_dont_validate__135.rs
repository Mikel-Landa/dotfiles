#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::fmt;

pub struct Email(String);

impl Email {
    pub fn parse(s: &str) -> Result<Self, EmailError> { ... }
}

// Implement Display for easy printing
impl fmt::Display for Email {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.0)
    }
}

// Implement AsRef for easy borrowing
impl AsRef<str> for Email {
    fn as_ref(&self) -> &str {
        &self.0
    }
}
;
Ok(())
}
fn main() {}
