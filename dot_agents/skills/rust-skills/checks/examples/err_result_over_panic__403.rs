#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// Library: NEVER panic on user input
pub fn parse(input: &str) -> Result<Ast, ParseError> {
    // Always return Result
}

// Application: Can panic at top level for critical failures
fn main() {
    if let Err(e) = run() {
        eprintln!("Fatal error: {}", e);
        std::process::exit(1);
    }
}
