#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Generic functions across crate boundaries often need #[inline]
// Because the generic code is compiled in the calling crate

// In library crate:
#[inline]  // Allow inlining in downstream crates
pub fn generic_function<T: Display>(x: T) {
    println!("{}", x);
}

// Without #[inline], the generic function can't be inlined
// across crate boundaries even if beneficial
;
Ok(())
}
fn main() {}
