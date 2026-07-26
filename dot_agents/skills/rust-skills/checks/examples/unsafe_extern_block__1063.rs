#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Rust 2024 style
unsafe extern "C" {
    // `strlen` is genuinely unsafe: caller must pass a null-terminated pointer.
    pub unsafe fn strlen(s: *const std::ffi::c_char) -> usize;

    // `memcpy` is unsafe: caller must ensure non-overlapping, valid regions.
    pub unsafe fn memcpy(dst: *mut u8, src: *const u8, n: usize) -> *mut u8;

    // A function that is always safe to call (hypothetical pure query).
    pub safe fn rust_version_major() -> u32;

    // Statics are unsafe to access unless you can guarantee no data races.
    pub unsafe static errno: std::ffi::c_int;
}

// Call sites remain unchanged for `unsafe` items:
fn copy_bytes(dst: *mut u8, src: *const u8, n: usize) {
    // SAFETY: dst and src are non-overlapping, both valid for n bytes.
    unsafe { memcpy(dst, src, n) };
}

// Call sites for `safe` items need no unsafe block:
fn show_version() {
    println!("major: {}", rust_version_major());
}
;
Ok(())
}
fn main() {}
