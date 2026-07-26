#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::marker::PhantomData;

// Owns T conceptually (like Box<T>)
struct Container<T> {
    ptr: *mut T,
    _marker: PhantomData<T>,  // Acts like we own a T
}

// Drop will be called on T when Container drops
impl<T> Drop for Container<T> {
    fn drop(&mut self) {
        unsafe {
            std::ptr::drop_in_place(self.ptr);
        }
    }
}
;
Ok(())
}
fn main() {}
