#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn process_in_chunks(mut items: Vec<Item>, chunk_size: usize) {
    while !items.is_empty() {
        let chunk: Vec<_> = items.drain(..chunk_size.min(items.len())).collect();
        process_chunk(chunk);
    }
}
;
Ok(())
}
fn main() {}
