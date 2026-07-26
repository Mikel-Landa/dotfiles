#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Small type with Copy - implicit duplication
#[derive(Clone, Copy, Debug)]
struct Point {
    x: f64,
    y: f64,
}

fn distance(p1: Point, p2: Point) -> f64 {
    ((p2.x - p1.x).powi(2) + (p2.y - p1.y).powi(2)).sqrt()
}

let origin = Point { x: 0.0, y: 0.0 };
let target = Point { x: 3.0, y: 4.0 };

let d1 = distance(origin, target); // Implicitly copied
let d2 = distance(origin, target); // Still works!
// origin and target remain valid
;
Ok(())
}
fn main() {}
