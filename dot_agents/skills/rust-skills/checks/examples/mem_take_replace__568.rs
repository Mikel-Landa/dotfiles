#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::mem;

struct FileWriter {
    buffer: Vec<u8>,
    // imagine a real file handle here
}

impl Drop for FileWriter {
    fn drop(&mut self) {
        let data = mem::take(&mut self.buffer);
        // flush `data` to disk without an extra allocation
        let _ = data; // pretend this writes somewhere
    }
}
;
Ok(())
}
fn main() {}
