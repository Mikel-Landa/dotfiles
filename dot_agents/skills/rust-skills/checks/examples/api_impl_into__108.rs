#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// ❌ Trait objects need Sized
fn process(handler: impl Into<Box<dyn Handler>>) { }
// Better: just take Box<dyn Handler> directly

// ❌ Recursive types
struct Node {
    children: Vec<impl Into<Node>>,  // Error: impl Trait not allowed here
}

// ❌ Performance-critical hot paths (minor overhead of trait dispatch)
fn hot_path(value: impl Into<u64>) {
    // Consider taking u64 directly if called billions of times
}

// ❌ When you need to name the type
fn returns_impl() -> impl Into<String> { }  // Opaque, hard to use
;
Ok(())
}
fn main() {}
