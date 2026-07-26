#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use serde::{Serialize, Deserialize};

// Externally tagged (default) — {"Circle":{"radius":5.0}}
// Good for: Rust-to-Rust, when the variant name IS the key
#[derive(Serialize, Deserialize, Debug)]
enum ShapeExternal {
    Circle { radius: f64 },
    Rectangle { width: f64, height: f64 },
}

// Internally tagged — {"type":"Circle","radius":5.0}
// Good for: REST APIs with a discriminator field; all variants must be structs/maps
#[derive(Serialize, Deserialize, Debug)]
#[serde(tag = "type")]
enum ShapeInternal {
    Circle { radius: f64 },
    Rectangle { width: f64, height: f64 },
}

// Adjacently tagged — {"t":"Circle","c":{"radius":5.0}}
// Good for: when variants may contain primitives or vecs (internally tagged can't handle those)
#[derive(Serialize, Deserialize, Debug)]
#[serde(tag = "t", content = "c")]
enum ShapeAdjacent {
    Circle { radius: f64 },
    Rectangle { width: f64, height: f64 },
    Count(u32),  // tuple variant — works here, but NOT with internally tagged
}

// Untagged — {"radius":5.0}
// Good for: wrapping a small number of clearly distinct types; avoid otherwise
#[derive(Serialize, Deserialize, Debug)]
#[serde(untagged)]
enum Value {
    Integer(i64),
    Float(f64),
    Text(String),
}
;
Ok(())
}
fn main() {}
