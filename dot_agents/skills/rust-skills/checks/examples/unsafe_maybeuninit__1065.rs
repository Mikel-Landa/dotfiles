#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::mem::MaybeUninit;

// ---- 1. Single value ----
let mut x = MaybeUninit::<u32>::uninit();
x.write(42);
// SAFETY: we just wrote a valid u32 via `write`, so the value is initialized.
let value: u32 = unsafe { x.assume_init() };

// ---- 2. Array initialization (manual, element-by-element) ----
// `[const { MaybeUninit::uninit() }; N]` works for any `T` (no `Copy` bound).
let mut buf: [MaybeUninit<u8>; 1024] = [const { MaybeUninit::uninit() }; 1024];
for elem in &mut buf {
    elem.write(0u8);
}
// SAFETY: every element was written above.
// `From<[MaybeUninit<T>; N]> for MaybeUninit<[T; N]>` is stable since Rust 1.95.
let buf: [u8; 1024] = unsafe {
    MaybeUninit::<[u8; 1024]>::from(buf).assume_init()
};

// ---- 3. Growing a Vec into spare capacity ----
fn fill_vec(v: &mut Vec<u8>, extra: usize) {
    v.reserve(extra);
    let spare = v.spare_capacity_mut(); // &mut [MaybeUninit<u8>]
    for slot in spare.iter_mut().take(extra) {
        slot.write(0u8);
    }
    // SAFETY: we initialized `extra` elements in the spare capacity.
    unsafe { v.set_len(v.len() + extra) };
}
;
Ok(())
}
fn main() {}
