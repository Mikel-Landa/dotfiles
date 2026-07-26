#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::mem::size_of;

#[derive(Clone, Copy)]
struct Miles(f64);

#[derive(Clone, Copy)]
struct Kilometers(f64);

// Same size as raw f64
assert_eq!(size_of::<Miles>(), size_of::<f64>());
assert_eq!(size_of::<Kilometers>(), size_of::<f64>());

// But can't accidentally mix them
fn drive(distance: Miles) { ... }

let km = Kilometers(100.0);
drive(km);  // Error: expected Miles, found Kilometers

// Explicit conversion
impl From<Kilometers> for Miles {
    fn from(km: Kilometers) -> Self {
        Miles(km.0 * 0.621371)
    }
}

drive(km.into());  // Explicit, visible conversion
;
Ok(())
}
fn main() {}
