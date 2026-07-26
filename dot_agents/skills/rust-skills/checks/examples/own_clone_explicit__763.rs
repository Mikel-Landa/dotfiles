#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Instead of cloning, consider:

// 1. References
fn process(data: &MyType) { } // Borrow instead of clone

// 2. Cow for conditional cloning
fn process(data: Cow<'_, str>) { } // Clone only if mutation needed

// 3. Arc for shared ownership
let shared = Arc::new(expensive_data);
let handle = shared.clone(); // Cheap: just increments counter

// 4. Passing by value when caller is done with it
fn consume(data: MyType) { } // Caller moves, no clone
;
Ok(())
}
fn main() {}
