#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// std::fmt::Write - for String, &mut String
use std::fmt::Write as FmtWrite;
let mut s = String::new();
write!(&mut s, "Hello {}", 42).unwrap();

// std::io::Write - for Vec<u8>, File, TcpStream, etc.
use std::io::Write as IoWrite;
let mut v: Vec<u8> = Vec::new();
write!(&mut v, "Hello {}", 42).unwrap();

// Both can fail in principle, but String/Vec never fail
// Still need .unwrap() due to Result return type
;
Ok(())
}
fn main() {}
