#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Safe wrapper: the single unsafe operation is clearly isolated.
fn sum_at(ptr: *const i32, len: usize, index: usize) -> i32 {
    assert!(index < len, "index out of bounds");
    // SAFETY: index < len guarantees ptr.add(index) is within the allocation.
    let value = unsafe { *ptr.add(index) };
    value + 1
}
;
Ok(())
}
fn main() {}
