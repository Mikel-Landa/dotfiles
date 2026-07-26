#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
trait Limit {
    const MAX: usize;
    const MIN: usize;
}

impl Limit for SmallBuffer {
    const MAX: usize = 256;
    const MIN: usize = 16;
}

// Generic associated constants
struct Container<T> {
    data: Vec<T>,
}

impl<T> Container<T> {
    const EMPTY: Self = Self { data: Vec::new() };
}
;
Ok(())
}
fn main() {}
