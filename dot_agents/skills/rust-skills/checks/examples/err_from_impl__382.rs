#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// ❌ Too broad - conflicts with other From impls
impl<E: std::error::Error> From<E> for AppError {
    fn from(err: E) -> Self {
        AppError::Other(err.to_string())
    }
}

// ✅ Specific implementations
impl From<std::io::Error> for AppError { ... }
impl From<ParseIntError> for AppError { ... }
;
Ok(())
}
fn main() {}
