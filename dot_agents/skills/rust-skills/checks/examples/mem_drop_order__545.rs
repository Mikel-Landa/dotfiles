#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::mem::ManuallyDrop;

struct ResourcePair {
    // child must be cleaned up before parent
    child: ManuallyDrop<Child>,
    parent: Parent,
}

impl Drop for ResourcePair {
    fn drop(&mut self) {
        // SAFETY: `child` is not accessed after this point
        unsafe { ManuallyDrop::drop(&mut self.child) };
        // `parent` drops automatically after this block
    }
}

struct Child;
struct Parent;
;
Ok(())
}
fn main() {}
