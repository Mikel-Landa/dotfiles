#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// SAFETY: ptr was obtained from Box::into_raw, so it's valid
// and properly aligned. We're taking back ownership.
let boxed = unsafe { Box::from_raw(ptr) };
;
Ok(())
}
fn main() {}
