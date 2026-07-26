#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// All consume self and return owned data
let string: String = "hello".to_string();
let bytes: Vec<u8> = string.into_bytes();  // String consumed

let path = PathBuf::from("/foo");
let os_string: OsString = path.into_os_string();  // PathBuf consumed

let boxed: Box<[i32]> = vec![1, 2, 3].into_boxed_slice();  // Vec consumed

let vec: Vec<u8> = boxed.into_vec();  // Box consumed
;
Ok(())
}
fn main() {}
