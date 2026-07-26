#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// SAFETY: libc::getenv is safe to call with a null-terminated
// string. We ensure null termination with CString::new.
// The returned pointer is valid for the lifetime of the environment.
let value = unsafe { libc::getenv(key.as_ptr()) };
;
Ok(())
}
fn main() {}
