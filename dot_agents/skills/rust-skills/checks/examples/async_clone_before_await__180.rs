#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Limit borrow scope to before await
async fn scoped(data: Arc<Data>) {
    // Scope 1: borrow, compute, drop borrow
    let computed = {
        let slice = &data.items[..];  // Borrow
        compute_something(slice)       // Use
    };  // Borrow ends here
    
    // Now safe to await
    expensive_async_operation().await;
    
    use_computed(computed);
}
;
Ok(())
}
fn main() {}
