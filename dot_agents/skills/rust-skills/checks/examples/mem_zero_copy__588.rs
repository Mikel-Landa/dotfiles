#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Zero-copy: returns references to original data
fn get_lines(data: &str) -> Vec<&str> {
    data.lines().collect()  // Just pointers!
}

// Zero-copy with slices
fn process_packet(buffer: &[u8]) -> (&[u8], &[u8]) {
    let header = &buffer[0..16];  // Just a pointer + length
    let body = &buffer[16..];     // Just a pointer + length
    (header, body)
}
;
Ok(())
}
fn main() {}
