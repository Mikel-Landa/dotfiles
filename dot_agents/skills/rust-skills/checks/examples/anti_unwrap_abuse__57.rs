#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// unwrap() - no context
let file = File::open(path).unwrap();
// Panics with: "called `Result::unwrap()` on an `Err` value: Os { code: 2, ... }"

// expect() - adds context
let file = File::open(path)
    .expect("config file should exist at startup");
// Panics with: "config file should exist at startup: Os { code: 2, ... }"

// But still use only for invariants, not error handling
;
Ok(())
}
fn main() {}
