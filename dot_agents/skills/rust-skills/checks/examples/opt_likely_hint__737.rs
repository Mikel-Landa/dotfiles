#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn process(data: &Data) -> i32 {
    if data.is_corrupted() {
        std::hint::cold_path(); // tell the optimizer this branch is rare
        return handle_corruption(data);
    }
    fast_path(data)
}
;
Ok(())
}
fn main() {}
