#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Instead of: a.iter().chain(b.iter()).chain(c.iter())
let all = [a, b, c];
for item in all.iter().flat_map(|slice| slice.iter()) {
    process(item);
}
;
Ok(())
}
fn main() {}
