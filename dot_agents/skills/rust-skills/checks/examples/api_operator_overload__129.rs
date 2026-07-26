#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
use std::ops::{Add, Neg};

#[derive(Debug, Clone, Copy, PartialEq)]
struct Vector2 {
    x: f64,
    y: f64,
}

impl Vector2 {
    pub fn new(x: f64, y: f64) -> Self {
        Vector2 { x, y }
    }

    pub fn dot(self, other: Vector2) -> f64 {
        self.x * other.x + self.y * other.y
    }
}

// Add for owned values
impl Add for Vector2 {
    type Output = Vector2;

    fn add(self, rhs: Vector2) -> Vector2 {
        Vector2::new(self.x + rhs.x, self.y + rhs.y)
    }
}

// Also implement for references — avoids forcing callers to clone
impl Add for &Vector2 {
    type Output = Vector2;

    fn add(self, rhs: &Vector2) -> Vector2 {
        Vector2::new(self.x + rhs.x, self.y + rhs.y)
    }
}

impl Neg for Vector2 {
    type Output = Vector2;

    fn neg(self) -> Vector2 {
        Vector2::new(-self.x, -self.y)
    }
}

fn main() {
    let a = Vector2::new(1.0, 2.0);
    let b = Vector2::new(3.0, 4.0);

    let c = a + b;               // owned
    let d = &a + &b;             // borrowed — no clone needed
    let e = -a;

    assert_eq!(c, Vector2::new(4.0, 6.0));
    assert_eq!(d, Vector2::new(4.0, 6.0));
    assert_eq!(e, Vector2::new(-1.0, -2.0));
}
