#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use likely_stable::{likely, unlikely};

fn check(value: i32) -> bool {
    if unlikely(value < 0) {
        handle_negative()
    } else if likely(value < 1000) {
        handle_common()
    } else {
        handle_large()
    }
}
;
Ok(())
}
fn main() {}
