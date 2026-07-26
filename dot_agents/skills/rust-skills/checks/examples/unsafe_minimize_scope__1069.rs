#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// In a genuinely unsafe fn, 2024 edition still requires unsafe {} per op.
/// # Safety
///
/// `ptr` must be valid for reads for `len` bytes and properly aligned.
pub unsafe fn process(ptr: *const u8, len: usize) -> Vec<u8> {
    let mut result = Vec::with_capacity(len); // safe — outside any unsafe block
    for i in 0..len {
        // SAFETY: caller guarantees ptr is valid for len bytes; i < len.
        let byte = unsafe { *ptr.add(i) };
        result.push(byte);
    }
    result
}
;
Ok(())
}
fn main() {}
