#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
let results = processor.process_batch(&items)?;
assert!(results.all_succeeded());
;
Ok(())
}
fn main() {}
