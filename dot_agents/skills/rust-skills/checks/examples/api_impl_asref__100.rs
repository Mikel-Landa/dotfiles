#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// When T itself might be passed
fn process<T: AsRef<U>, U>(value: T) {
    let inner: &U = value.as_ref();
}

// More flexible: accept T or &T
fn process<T: AsRef<U> + ?Sized, U: ?Sized>(value: &T) {
    let inner: &U = value.as_ref();
}
;
Ok(())
}
fn main() {}
