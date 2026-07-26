#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::marker::PhantomData;

// PhantomData is zero-sized, doesn't affect layout
#[repr(transparent)]
struct TypedHandle<T> {
    raw: u64,
    _marker: PhantomData<T>,  // Zero-sized, ignored for layout
}

// Still same layout as u64
assert_eq!(size_of::<TypedHandle<String>>(), size_of::<u64>());
;
Ok(())
}
fn main() {}
