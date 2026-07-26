#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
/// Reads a value from a raw pointer.
///
/// # Safety
///
/// The caller must ensure that:
/// - `ptr` is valid for reads of `size_of::<T>()` bytes
/// - `ptr` is properly aligned for type `T`
/// - `ptr` points to a properly initialized value of type `T`
/// - The memory referenced by `ptr` is not mutated during this call
pub unsafe fn read_ptr<T>(ptr: *const T) -> T {
    ptr.read()
}

/// Creates a `String` from raw parts.
///
/// # Safety
///
/// The caller must guarantee that:
/// - `ptr` was allocated by the same allocator that `String` uses
/// - `len` is less than or equal to `cap`
/// - The first `len` bytes at `ptr` are valid UTF-8
/// - `cap` is the capacity that `ptr` was allocated with
/// - No other code will use `ptr` after this call (ownership is transferred)
///
/// Violating these requirements leads to undefined behavior including
/// memory corruption, use-after-free, or invalid UTF-8 in strings.
pub unsafe fn string_from_raw(ptr: *mut u8, len: usize, cap: usize) -> String {
    String::from_raw_parts(ptr, len, cap)
}
;
Ok(())
}
fn main() {}
