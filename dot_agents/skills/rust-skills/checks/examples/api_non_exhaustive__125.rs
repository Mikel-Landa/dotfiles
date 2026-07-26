#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
#[non_exhaustive]
pub struct Point {
    pub x: f64,
    pub y: f64,
}

impl Point {
    // Provide constructor
    pub fn new(x: f64, y: f64) -> Self {
        Point { x, y }
    }
}

// External code can read fields but not construct with literals
fn external(p: Point) {
    println!("x: {}, y: {}", p.x, p.y);  // Reading is fine
    
    // let p2 = Point { x: 1.0, y: 2.0 };  // Error!
    let p2 = Point::new(1.0, 2.0);  // Must use constructor
}
;
Ok(())
}
fn main() {}
