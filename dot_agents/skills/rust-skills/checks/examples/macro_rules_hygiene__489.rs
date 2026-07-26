#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// lib.rs
pub fn log_value(v: &str) {
    println!("[log] {v}");
}

#[macro_export]
macro_rules! log {
    ($val:expr) => {
        // `$crate` always expands to the crate that defined this macro.
        $crate::log_value(&format!("{:?}", $val));
    };
}
;
Ok(())
}
fn main() {}
