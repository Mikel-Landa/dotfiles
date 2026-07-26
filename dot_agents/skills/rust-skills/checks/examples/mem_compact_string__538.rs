#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use smartstring::{SmartString, LazyCompact};

// Default is LazyCompact: 24 bytes inline capacity
let s: SmartString<LazyCompact> = "short string".into();

// Compact mode: 23 bytes inline on 64-bit
use smartstring::Compact;
let s: SmartString<Compact> = "hello".into();
;
Ok(())
}
fn main() {}
