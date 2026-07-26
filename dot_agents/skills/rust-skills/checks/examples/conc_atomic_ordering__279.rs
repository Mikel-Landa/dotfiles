#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
#[cfg(loom)]
use loom::sync::atomic::{AtomicBool, Ordering};

#[cfg(loom)]
#[test]
fn test_handoff() {
    loom::model(|| {
        // ... spawn threads, assert invariants
    });
}
;
Ok(())
}
fn main() {}
