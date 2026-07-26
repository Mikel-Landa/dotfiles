#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// ✅ Pure functions (no side effects)
#[must_use]
fn add(a: i32, b: i32) -> i32 { a + b }

// ✅ Builder methods returning Self
#[must_use = "builder methods return a new builder"]
fn with_timeout(self, t: Duration) -> Self { ... }

// ✅ Fallible operations
#[must_use]
fn try_parse(s: &str) -> Result<Data, ParseError> { ... }

// ✅ Iterators and futures (lazy)
#[must_use = "iterators are lazy and do nothing unless consumed"]
struct Map<I, F> { ... }

// ❌ Side-effecting functions where result is optional
fn log(msg: &str) -> Result<(), io::Error> { ... }  // Might be ok to ignore

// ❌ Methods with useful side effects
fn vec.push(item);  // Mutates vec, no return to use
;
Ok(())
}
fn main() {}
