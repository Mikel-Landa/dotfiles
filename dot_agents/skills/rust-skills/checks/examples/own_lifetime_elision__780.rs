#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// ✅ Elision works
fn trim(s: &str) -> &str { s.trim() }
fn first(v: &[i32]) -> Option<&i32> { v.first() }
fn name(&self) -> &str { &self.name }

// ❌ Elision fails - multiple inputs, ambiguous output
fn pick(a: &str, b: &str, first: bool) -> &str // Error!

// ✅ Fixed with explicit lifetime
fn pick<'a>(a: &'a str, b: &'a str, first: bool) -> &'a str {
    if first { a } else { b }
}
;
Ok(())
}
fn main() {}
