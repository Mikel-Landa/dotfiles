#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
/// Returns the byte at `ptr + offset`.
///
/// # Safety
///
/// - `ptr` must be valid for reads for at least `offset + 1` bytes.
/// - `ptr` must not be null and must be properly aligned for `u8`.
/// - The memory must not be mutated for the duration of this call.
pub unsafe fn read_at(ptr: *const u8, offset: usize) -> u8 {
    // SAFETY: caller guarantees ptr is valid for at least offset + 1 bytes,
    // so ptr.add(offset) is in bounds and dereferenceable.
    unsafe { *ptr.add(offset) }
}

fn process(slice: &[u8]) -> Option<u8> {
    if slice.len() > 10 {
        // SAFETY: we just checked that slice has at least 11 elements,
        // so index 10 is within bounds.
        Some(unsafe { *slice.as_ptr().add(10) })
    } else {
        None
    }
}
;
Ok(())
}
fn main() {}
