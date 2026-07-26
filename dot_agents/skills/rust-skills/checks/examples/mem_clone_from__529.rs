#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
let mut buffer = String::with_capacity(1024);

for source in sources {
    buffer.clone_from(source);  // Reuses allocation if capacity sufficient
    process(&buffer);
}

// If source.len() <= 1024, no allocation happens
// Just copies bytes into existing buffer
;
Ok(())
}
fn main() {}
