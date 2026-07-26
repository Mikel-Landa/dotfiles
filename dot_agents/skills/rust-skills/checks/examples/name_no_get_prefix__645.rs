#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// No get_ prefix
String::len()
Vec::len()
Vec::capacity()
Vec::is_empty()
Path::file_name()
Option::is_some()
Result::is_ok()

// With get - returns Option or does lookup
Vec::get(index)
HashMap::get(key)
BTreeMap::get(key)
;
Ok(())
}
fn main() {}
