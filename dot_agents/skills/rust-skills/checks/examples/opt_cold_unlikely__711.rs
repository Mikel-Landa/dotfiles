#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn get_unchecked(&self, index: usize) -> &T {
    if index >= self.len {
        cold_bounds_panic(index, self.len);
    }
    unsafe { &*self.ptr.add(index) }
}

#[cold]
#[inline(never)]
fn cold_bounds_panic(index: usize, len: usize) -> ! {
    panic!("index out of bounds: the len is {} but the index is {}", len, index);
}
;
Ok(())
}
fn main() {}
