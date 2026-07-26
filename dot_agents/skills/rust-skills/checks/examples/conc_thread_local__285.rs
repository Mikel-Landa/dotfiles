#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::cell::RefCell;

thread_local! {
    static BUFFER: RefCell<Vec<u8>> = RefCell::new(Vec::with_capacity(4096));
}

fn append_to_buffer(data: &[u8]) {
    BUFFER.with_borrow_mut(|buf| buf.extend_from_slice(data));
}

fn flush_buffer() -> Vec<u8> {
    BUFFER.with_borrow_mut(|buf| std::mem::take(buf))
}
;
Ok(())
}
fn main() {}
