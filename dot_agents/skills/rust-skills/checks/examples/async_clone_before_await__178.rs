#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Bad: clone everything eagerly
async fn wasteful(data: Arc<LargeData>) {
    let data = (*data).clone();  // Clones entire LargeData
    async_work().await;
    use_one_field(&data.small_field);
}

// Good: clone only what you need
async fn efficient(data: Arc<LargeData>) {
    let small = data.small_field.clone();  // Clone only needed field
    async_work().await;
    use_one_field(&small);
}

// Good: if you need the whole thing, keep the Arc
async fn arc_efficient(data: Arc<LargeData>) {
    let data = data.clone();  // Cheap Arc clone
    async_work().await;
    use_data(&data);  // Access through Arc
}
;
Ok(())
}
fn main() {}
