#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// String - reuses capacity
let mut s = String::with_capacity(100);
s.clone_from(&other_string);

// Vec<T> - reuses capacity
let mut v: Vec<u8> = Vec::with_capacity(1000);
v.clone_from(&other_vec);

// HashMap - reuses buckets
let mut map = HashMap::with_capacity(100);
map.clone_from(&other_map);

// PathBuf - reuses capacity
let mut path = PathBuf::with_capacity(256);
path.clone_from(&other_path);
;
Ok(())
}
fn main() {}
