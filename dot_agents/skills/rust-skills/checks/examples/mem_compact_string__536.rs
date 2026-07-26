#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use compact_str::CompactString;

struct User {
    id: u64,
    // CompactString: 24 bytes, but strings ≤ 23 bytes are inline (no heap)
    username: CompactString,
    email: CompactString,
}

// Most usernames fit inline = zero heap allocations
// Same memory footprint as String but way fewer allocations
;
Ok(())
}
fn main() {}
