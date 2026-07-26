#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
/// A type that can be safely zeroed.
///
/// # Safety
///
/// Implementing this trait guarantees that:
/// - All bit patterns of zeros represent a valid value of this type
/// - The type has no padding bytes that could leak data
/// - The type contains no references or pointers
pub unsafe trait Zeroable {
    fn zeroed() -> Self;
}

// SAFETY: u32 is a primitive integer type where all zero bits
// represent a valid value (0).
unsafe impl Zeroable for u32 {
    fn zeroed() -> Self {
        0
    }
}
;
Ok(())
}
fn main() {}
