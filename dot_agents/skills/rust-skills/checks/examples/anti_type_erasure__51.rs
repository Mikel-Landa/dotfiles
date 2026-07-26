#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Return position - caller doesn't need to know concrete type
fn process() -> impl Future<Output = Result> { }

// Argument position - like generics but simpler
fn handle(handler: impl Handler) { }

// Return-position impl Trait in traits (RPITIT) is stable since Rust 1.75
trait Processor {
    // Use impl Trait when callers don't need to name the return type:
    fn process(&self) -> impl Display;  // stable, idiomatic (Rust 1.75+)

    // Use an associated type when callers need to name or constrain the type:
    type Output: Display;
    fn process_named(&self) -> Self::Output;
}
;
Ok(())
}
fn main() {}
