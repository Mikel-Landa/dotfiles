#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn reuse_buffer(data: &[Vec<i32>]) {
    let mut buffer = Vec::new();
    
    for batch in data {
        buffer.clear();
        buffer.extend(batch.iter().filter(|&&x| x > 0).copied());
        process(&buffer);
    }
}
;
Ok(())
}
fn main() {}
