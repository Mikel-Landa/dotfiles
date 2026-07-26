#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Usually combine both for maximum effect
#[cold]
#[inline(never)]
fn error_path() -> Error {
    // Complex error construction stays out of hot code
    Error {
        backtrace: Backtrace::capture(),
        context: gather_context(),
    }
}
;
Ok(())
}
fn main() {}
