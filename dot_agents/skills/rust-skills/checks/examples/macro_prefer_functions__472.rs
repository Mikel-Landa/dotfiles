#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// A generic function is clearer, debuggable, and just as efficient.
#[inline]
fn double<T>(x: T) -> T
where
    T: std::ops::Mul<Output = T> + Copy,
{
    x * x  // or x + x for integer-like types
}

fn main() {
    let n = double(21_i32);
    println!("{n}");
}
