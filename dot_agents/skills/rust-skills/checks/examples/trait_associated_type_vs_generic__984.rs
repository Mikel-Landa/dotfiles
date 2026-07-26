#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// ----- Associated type: one output per implementor -----
// Mirrors std::iter::Iterator { type Item; }

trait Parser {
    type Output;
    fn parse(&self, input: &str) -> Option<Self::Output>;
}

struct JsonParser;
struct NumberParser;

#[derive(Debug)]
struct JsonValue(String);

impl Parser for JsonParser {
    type Output = JsonValue;
    fn parse(&self, input: &str) -> Option<JsonValue> {
        Some(JsonValue(input.to_owned()))
    }
}

impl Parser for NumberParser {
    type Output = f64;
    fn parse(&self, input: &str) -> Option<f64> {
        input.trim().parse().ok()
    }
}

// No turbofish needed — `P::Output` is unambiguous.
fn run<P: Parser>(p: &P, s: &str) -> Option<P::Output> {
    p.parse(s)
}

// ----- Generic parameter: multiple impls on the same type -----
// Mirrors std::ops::Add<Rhs> and std::convert::From<T>.

#[derive(Debug, Clone, Copy)]
struct Vec2 { x: f64, y: f64 }

// One type implementing the same "add" concept for two different Rhs types.
impl std::ops::Add<Vec2> for Vec2 {
    type Output = Vec2;
    fn add(self, rhs: Vec2) -> Vec2 { Vec2 { x: self.x + rhs.x, y: self.y + rhs.y } }
}

impl std::ops::Add<f64> for Vec2 {
    type Output = Vec2;
    fn add(self, rhs: f64) -> Vec2 { Vec2 { x: self.x + rhs, y: self.y + rhs } }
}

fn demo() {
    let a = Vec2 { x: 1.0, y: 2.0 };
    let b = Vec2 { x: 3.0, y: 4.0 };
    let _ = a + b;       // Add<Vec2>
    let _ = a + 10.0;    // Add<f64>

    let p = NumberParser;
    if let Some(n) = run(&p, " 3.14 ") {
        println!("{n}");
    }
}
;
Ok(())
}
fn main() {}
