#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// is_ prefix
vec.is_empty()
option.is_some()
option.is_none()
result.is_ok()
result.is_err()
char.is_alphabetic()
str.is_ascii()
path.is_file()
path.is_dir()

// has_ prefix (less common in std)
iterator.has_next()  // conceptual

// Checking methods
str.contains("foo")      // Not is_ because takes argument
str.starts_with("bar")   // Descriptive verb phrase
str.ends_with("baz")
;
Ok(())
}
fn main() {}
