#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Rust 2024 — unsafe(...) wrapper makes the risk explicit
#[unsafe(no_mangle)]
pub extern "C" fn init() {
    // ...
}

#[unsafe(export_name = "plugin_entry")]
pub fn plugin_main() {
    // ...
}

#[unsafe(link_section = ".init_array")]
static INIT: extern "C" fn() = init;
;
Ok(())
}
fn main() {}
