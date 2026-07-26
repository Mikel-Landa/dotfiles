#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// SAFETY: We just checked that i < self.len() above.
// The bounds check cannot be elided by the optimizer
// because len() is not inlined.
unsafe { self.data.get_unchecked(i) }
;
Ok(())
}
fn main() {}
