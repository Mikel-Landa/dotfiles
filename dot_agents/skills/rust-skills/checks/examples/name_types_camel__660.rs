#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Type aliases also use UpperCamelCase
type Result<T> = std::result::Result<T, Error>;
type BoxedFuture<'a, T> = Pin<Box<dyn Future<Output = T> + Send + 'a>>;
;
Ok(())
}
fn main() {}
