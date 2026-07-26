#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// WARN: Suspicious use of + in a << expression
let bits = 1 << 4 + 1;  // Probably meant (1 << 4) + 1 or 1 << (4 + 1)

// WARN: Suspicious use of | in a + expression
let value = x | 1 + y;  // Probably meant (x | 1) + y or x | (1 + y)
;
Ok(())
}
fn main() {}
