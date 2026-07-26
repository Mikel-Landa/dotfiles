#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::borrow::Cow;

fn process(input: Cow<str>) -> Cow<str> {
    if needs_modification(&input) {
        Cow::Owned(modify(&input))  // Clone only if needed
    } else {
        input  // No clone
    }
}
;
Ok(())
}
fn main() {}
