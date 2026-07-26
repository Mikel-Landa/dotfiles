#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Generic functions are already candidates for per-monomorphization inlining
// But #[inline] helps ensure it across crates

#[inline]
pub fn min<T: Ord>(a: T, b: T) -> T {
    if a < b { a } else { b }
}
;
Ok(())
}
fn main() {}
