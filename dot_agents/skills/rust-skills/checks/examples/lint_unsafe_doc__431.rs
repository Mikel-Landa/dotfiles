#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
pub fn read_data(ptr: *const u8, len: usize) -> &[u8] {
    // SAFETY: Caller guarantees:
    // - ptr is valid for reads of len bytes
    // - ptr is properly aligned for u8
    // - the memory is initialized
    // - no mutable references exist to this memory
    unsafe {
        std::slice::from_raw_parts(ptr, len)
    }
}

impl Buffer {
    pub fn get_unchecked(&self, index: usize) -> &u8 {
        debug_assert!(index < self.len(), "index out of bounds");
        // SAFETY: We verified index < len in debug builds.
        // Callers must ensure index is within bounds.
        unsafe { self.data.get_unchecked(index) }
    }
}
;
Ok(())
}
fn main() {}
