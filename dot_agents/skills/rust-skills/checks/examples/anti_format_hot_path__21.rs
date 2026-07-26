#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::fmt::Write; // for the caller's write! into a String

struct Event {
    level: Level,
    message: String,
}

impl std::fmt::Display for Event {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "[{}] {}", self.level, self.message)
    }
}

// Caller controls allocation
let mut buf = String::new();
write!(buf, "{}", event)?;
;
Ok(())
}
fn main() {}
