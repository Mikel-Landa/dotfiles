#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn process_data(data: Vec<u32>) -> Vec<u32> {
    let backup = data; 
    transform(backup)
}

let my_data = vec![1, 2, 3, 4, 5];
let result = process_data(my_data.clone()); // Explicit: "I know this allocates"
// my_data still available

// Or better - take reference if you don't need ownership
fn process_data_ref(data: &[u32]) -> Vec<u32> {
    transform(data)
}
let result = process_data_ref(&my_data); // No clone needed
;
Ok(())
}
fn main() {}
