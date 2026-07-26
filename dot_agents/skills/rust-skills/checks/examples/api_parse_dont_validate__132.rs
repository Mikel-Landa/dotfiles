#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Port number (1-65535)
pub struct Port(u16);

impl Port {
    pub fn new(n: u16) -> Option<Self> {
        if n > 0 { Some(Port(n)) } else { None }
    }
    
    pub fn get(&self) -> u16 {
        self.0
    }
}

// Non-empty string
pub struct NonEmptyString(String);

impl NonEmptyString {
    pub fn new(s: impl Into<String>) -> Option<Self> {
        let s = s.into();
        if s.is_empty() { None } else { Some(Self(s)) }
    }
}

// Positive integer
pub struct PositiveI32(i32);

impl PositiveI32 {
    pub fn new(n: i32) -> Option<Self> {
        if n > 0 { Some(Self(n)) } else { None }
    }
}

// Bounded value
pub struct Percentage(u8);

impl Percentage {
    pub fn new(n: u8) -> Option<Self> {
        if n <= 100 { Some(Self(n)) } else { None }
    }
}
;
Ok(())
}
fn main() {}
