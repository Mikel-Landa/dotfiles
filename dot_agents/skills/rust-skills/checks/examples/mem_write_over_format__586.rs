#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::fmt::Write; // brings the write! target trait into scope

// format! in loop: new heap allocation on every iteration
for i in 0..1000 {
    let s = format!("item-{}", i);
    process(&s);
}

// write! with reuse: no allocation after the first iteration
let mut buf = String::with_capacity(32);
for i in 0..1000 {
    buf.clear();
    write!(&mut buf, "item-{}", i).unwrap();
    process(&buf);
}
;
Ok(())
}
fn main() {}
