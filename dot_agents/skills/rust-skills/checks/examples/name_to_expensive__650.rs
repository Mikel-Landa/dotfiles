#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// to_ methods - all allocate or compute
let s: String = slice.to_vec();           // Allocates Vec
let s: String = "hello".to_string();      // Allocates String
let s: String = "HELLO".to_lowercase();   // Allocates new String
let s: String = path.to_string_lossy().into_owned();  // May allocate

// Contrast with as_ methods - all are free
let slice: &[u8] = s.as_bytes();          // Just reinterpret
let str_ref: &str = string.as_str();      // Just reference
let path: &Path = Path::new("foo");       // Just reference
;
Ok(())
}
fn main() {}
