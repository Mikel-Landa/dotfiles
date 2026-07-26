#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::marker::PhantomData;

// Covariant in T (PhantomData<T>)
struct Producer<T> {
    _marker: PhantomData<T>,  // Covariant
}

// Contravariant in T (PhantomData<fn(T)>)
struct Consumer<T> {
    _marker: PhantomData<fn(T)>,  // Contravariant
}

// Invariant in T (PhantomData<fn(T) -> T>)
struct Both<T> {
    _marker: PhantomData<fn(T) -> T>,  // Invariant
}
;
Ok(())
}
fn main() {}
