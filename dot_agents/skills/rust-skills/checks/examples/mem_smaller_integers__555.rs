#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Safe: always succeeds (widening)
let small: u8 = 42;
let big: u32 = small.into();

// Fallible: may overflow (narrowing)
let big: u32 = 1000;
let small: u8 = big.try_into().expect("value out of range");

// Or use checked conversion
if let Ok(small) = u8::try_from(big) {
    use_small(small);
} else {
    handle_overflow();
}
;
Ok(())
}
fn main() {}
