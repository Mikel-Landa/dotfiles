#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// ❌ When size varies widely
fn parse_json_array(json: &str) -> ArrayVec<Value, ???> {
    // What capacity? JSON arrays can be any size
}

// ❌ When capacity is very large
let big: ArrayVec<u8, 1_000_000> = ArrayVec::new();  // 1MB on stack = bad

// ✅ Use SmallVec or Vec instead for these cases
;
Ok(())
}
fn main() {}
