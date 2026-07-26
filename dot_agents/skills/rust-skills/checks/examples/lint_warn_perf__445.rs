#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// WARN: Single-character string patterns
s.starts_with("x")  // Use char: 'x'
s.contains("a")     // Use char: 'a'

// WARN: iter().nth(0) instead of first()
iter.nth(0)  // Use: iter.first() or iter.next()

// WARN: Manual saturating arithmetic
if x > i32::MAX - y { i32::MAX } else { x + y }
// Use: x.saturating_add(y)
;
Ok(())
}
fn main() {}
