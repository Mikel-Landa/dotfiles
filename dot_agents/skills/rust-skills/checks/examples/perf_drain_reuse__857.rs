#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// clear: just empty
vec.clear();

// drain: empty and iterate
for item in vec.drain(..) {
    process(item);
}

// take: swap with empty, get ownership
let old_vec = std::mem::take(&mut vec);
;
Ok(())
}
fn main() {}
