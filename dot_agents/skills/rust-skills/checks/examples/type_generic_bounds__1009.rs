#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Supertrait bounds are implied
trait Foo: Clone + Debug {}

fn process<T: Foo>(value: T) {
    // T: Clone and T: Debug are implied by T: Foo
    let cloned = value.clone();
    println!("{:?}", cloned);
}

// Associated type bounds
fn process<I>(iter: I)
where
    I: Iterator,
    I::Item: Clone,  // Bound on associated type
{ }
;
Ok(())
}
fn main() {}
