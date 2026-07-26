#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
impl Name {
    // to_ = allocates/computes
    fn to_uppercase(&self) -> String {
        self.0.to_uppercase()
    }
    
    // to_ = creates new value
    fn to_string(&self) -> String {
        self.0.clone()
    }
    
    // as_ = free reference (cheap)
    fn as_str(&self) -> &str {
        &self.0
    }
}
;
Ok(())
}
fn main() {}
