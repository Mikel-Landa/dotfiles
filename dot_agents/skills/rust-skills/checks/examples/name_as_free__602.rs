#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// String
let s = String::from("hello");
let bytes: &[u8] = s.as_bytes();    // Free, returns &[u8]
let str_ref: &str = s.as_str();     // Free, returns &str

// Vec
let v = vec![1, 2, 3];
let slice: &[i32] = v.as_slice();   // Free, returns &[i32]

// Path
let p = PathBuf::from("/home");
let path: &Path = p.as_path();      // Free, returns &Path

// OsString
let os = OsString::from("hello");
let os_str: &OsStr = os.as_os_str(); // Free, returns &OsStr
;
Ok(())
}
fn main() {}
