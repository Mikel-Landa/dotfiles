#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Can add variants in minor versions
#[non_exhaustive]
pub enum ErrorKind {
    NotFound,
    PermissionDenied,
    TimedOut,
    // Future: can add Interrupted here without breaking changes
}

// Downstream code MUST have wildcard
match error.kind() {
    ErrorKind::NotFound => ...,
    ErrorKind::PermissionDenied => ...,
    ErrorKind::TimedOut => ...,
    _ => ...,  // Required by non_exhaustive
}

// Can add fields in minor versions
#[non_exhaustive]
pub struct Config {
    pub name: String,
    pub value: i32,
}

// Downstream CANNOT use struct literal syntax
// let config = Config { name: "test".into(), value: 42 };  // Error!

// Must use constructor
impl Config {
    pub fn new(name: impl Into<String>, value: i32) -> Self {
        Config { name: name.into(), value }
    }
}
;
Ok(())
}
fn main() {}
