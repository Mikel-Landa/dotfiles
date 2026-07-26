#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn get_index(&self, idx: usize) -> &T {
    if idx >= self.len {
        cold_out_of_bounds(idx, self.len);
    }
    unsafe { self.ptr.add(idx).as_ref().unwrap() }
}

#[cold]
#[inline(never)]
fn cold_out_of_bounds(idx: usize, len: usize) -> ! {
    panic!("index {} out of bounds for length {}", idx, len);
}
;
Ok(())
}
fn main() {}
