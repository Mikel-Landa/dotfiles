#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::marker::PhantomData;

// Borrows T for lifetime 'a
struct Ref<'a, T> {
    ptr: *const T,
    _marker: PhantomData<&'a T>,  // Acts like &'a T
}

// Compiler tracks lifetime correctly
impl<'a, T> Ref<'a, T> {
    fn get(&self) -> &'a T {
        unsafe { &*self.ptr }
    }
}
;
Ok(())
}
fn main() {}
