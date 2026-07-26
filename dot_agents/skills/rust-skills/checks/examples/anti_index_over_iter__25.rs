#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Iterator version can auto-vectorize
let sum: i32 = data.iter().sum();

// Manual indexing prevents vectorization
let mut sum = 0;
for i in 0..data.len() {
    sum += data[i];
}
;
Ok(())
}
fn main() {}
