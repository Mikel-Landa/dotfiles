#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct SessionId(String);

impl SessionId {
    pub fn new() -> Self {
        Self(uuid::Uuid::new_v4().to_string())
    }
    
    pub fn parse(s: &str) -> Result<Self, ParseError> {
        // Validate format
        uuid::Uuid::parse_str(s)?;
        Ok(Self(s.to_string()))
    }
    
    pub fn as_str(&self) -> &str {
        &self.0
    }
}
;
Ok(())
}
fn main() {}
