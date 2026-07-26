#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// https://github.com/sharkdp/fd/blob/master/src/walk.rs
struct ReceiverBuffer<'a, W> {
    buffer: Vec<DirEntry>,
    // ...
}

impl<'a, W: Write> ReceiverBuffer<'a, W> {
    fn new(...) -> Self {
        Self {
            buffer: Vec::with_capacity(MAX_BUFFER_LENGTH),
            // ...
        }
    }
}
;
Ok(())
}
fn main() {}
