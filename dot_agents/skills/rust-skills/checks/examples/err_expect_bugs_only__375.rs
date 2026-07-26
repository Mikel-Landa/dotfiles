#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// ❌ Bad messages
.expect("failed")                    // No context
.expect("should not be None")        // Doesn't explain why
.expect("Invalid state")             // Vague

// ✅ Good messages
.expect("BUG: HashMap entry exists after insert")
.expect("BUG: validated input must parse - validation is broken")
.expect("BUG: static regex compilation failed - regex syntax error in source")
;
Ok(())
}
fn main() {}
