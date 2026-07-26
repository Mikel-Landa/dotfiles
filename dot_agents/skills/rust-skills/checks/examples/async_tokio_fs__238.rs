#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// tokio::fs uses spawn_blocking internally
// For many small files, the overhead adds up

// Batch operations when possible
let paths: Vec<_> = entries.iter()
    .map(|e| e.path())
    .collect();

let contents = futures::future::try_join_all(
    paths.iter().map(|p| fs::read_to_string(p))
).await?;

// For heavy I/O, consider memory-mapped files
// (requires unsafe or mmap crate)
;
Ok(())
}
fn main() {}
