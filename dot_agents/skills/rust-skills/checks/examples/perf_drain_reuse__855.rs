#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Move all elements without reallocation
fn transfer_all(src: &mut Vec<Item>, dst: &mut Vec<Item>) {
    dst.extend(src.drain(..));
    // src is now empty but keeps capacity
}

// Move matching elements
fn transfer_matching(src: &mut Vec<Item>, dst: &mut Vec<Item>, predicate: impl Fn(&Item) -> bool) {
    let matching: Vec<_> = src.drain(..).filter(predicate).collect();
    dst.extend(matching);
}
;
Ok(())
}
fn main() {}
