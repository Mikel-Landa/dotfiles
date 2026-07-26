#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// ✅ Use for public API types that may evolve
#[non_exhaustive]
pub enum ApiError { ... }

#[non_exhaustive]
pub struct Options { ... }

// ✅ Use for error types
#[non_exhaustive]
pub enum MyError { ... }

// ❌ Don't use for internal types
enum InternalState { ... }  // Not public, no concern

// ❌ Don't use for stable, complete types
pub enum Ordering {  // Less, Equal, Greater is complete
    Less,
    Equal,
    Greater,
}
;
Ok(())
}
fn main() {}
