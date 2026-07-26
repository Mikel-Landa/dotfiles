#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use compact_str::CompactString;

// Inline storage for strings ≤ 23 bytes
let small: CompactString = "hello".into();  // No heap allocation

// Automatic heap fallback for larger strings
let large: CompactString = "x".repeat(100).into();

// String-like API
let mut s = CompactString::new("hello");
s.push_str(" world");
assert_eq!(s.as_str(), "hello world");

// Format macro
use compact_str::format_compact;
let s = format_compact!("value: {}", 42);
;
Ok(())
}
fn main() {}
