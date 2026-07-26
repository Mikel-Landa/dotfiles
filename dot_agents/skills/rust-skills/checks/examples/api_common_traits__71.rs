#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Point {
    pub x: f64,
    pub y: f64,
}

// Now everything works
println!("{:?}", point);
assert_eq!(point1, point2);
let copy = point;  // Copy, not just Clone

// For hashable types
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct UserId(u64);

let mut map: HashMap<UserId, User> = HashMap::new();
;
Ok(())
}
fn main() {}
