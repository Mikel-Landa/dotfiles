#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// No attribute - compiler decides (usually good for same-crate)
fn auto_decide() { }

// Suggest inlining - helps cross-crate
#[inline]
fn suggest_inline() { }

// Strongly suggest inlining - almost always inlined
#[inline(always)]
fn force_inline() { }

// Strongly suggest NOT inlining - for large/cold code
#[inline(never)]
fn prevent_inline() { }
;
Ok(())
}
fn main() {}
