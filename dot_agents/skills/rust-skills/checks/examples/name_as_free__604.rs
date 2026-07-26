#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
impl MyType {
    // GOOD: Free reference
    pub fn as_str(&self) -> &str {
        &self.inner
    }
    
    // GOOD: to_ signals allocation
    pub fn to_string(&self) -> String {
        format!("{}", self.value)
    }
    
    // GOOD: into_ signals ownership transfer
    pub fn into_inner(self) -> Inner {
        self.inner
    }
}
;
Ok(())
}
fn main() {}
