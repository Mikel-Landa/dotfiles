#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::io::Write;

// Bad: Allocate then write
fn bad_log(writer: &mut impl Write, msg: &str, code: u32) {
    let formatted = format!("[ERROR {}] {}", code, msg);  // Allocation!
    writer.write_all(formatted.as_bytes()).unwrap();
}

// Good: Write directly
fn good_log(writer: &mut impl Write, msg: &str, code: u32) {
    write!(writer, "[ERROR {}] {}", code, msg).unwrap();  // No allocation!
}
;
Ok(())
}
fn main() {}
