#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Now "serde_" typo → compiler warning: unexpected `cfg` condition value
// and tokio_unstable is a known cfg, so it compiles cleanly.
#[cfg(feature = "serde")]      // correct
impl serde::Serialize for MyType {}

#[cfg(tokio_unstable)]         // declared above — no warning
pub fn experimental() {}
;
Ok(())
}
fn main() {}
