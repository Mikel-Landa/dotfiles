#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn needs_capacity(v: &Vec<i32>) -> usize {
    v.capacity()  // Only Vec has capacity
}

fn might_grow(v: &mut Vec<i32>) {
    v.push(42);  // Slice can't push
}
;
Ok(())
}
fn main() {}
