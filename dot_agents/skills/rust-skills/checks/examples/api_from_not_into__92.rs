#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::convert::TryFrom;

struct PositiveInt(u32);

// Fallible conversion
impl TryFrom<i32> for PositiveInt {
    type Error = &'static str;
    
    fn try_from(value: i32) -> Result<Self, Self::Error> {
        if value > 0 {
            Ok(PositiveInt(value as u32))
        } else {
            Err("value must be positive")
        }
    }
}

// Usage
let pos = PositiveInt::try_from(42)?;   // From-style
let pos: PositiveInt = 42.try_into()?;  // Into-style (via blanket)
;
Ok(())
}
fn main() {}
