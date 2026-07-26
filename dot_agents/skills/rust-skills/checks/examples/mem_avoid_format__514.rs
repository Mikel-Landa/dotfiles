#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use compact_str::CompactString;

// Stack-allocated for strings <= 24 bytes
fn format_code(code: u32) -> CompactString {
    compact_str::format_compact!("ERR-{:04}", code)
    // Stack-allocated if result is small enough
}
;
Ok(())
}
fn main() {}
