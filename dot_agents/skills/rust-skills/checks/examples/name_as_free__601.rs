#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
impl MyString {
    // as_ - free reference conversion
    pub fn as_str(&self) -> &str {
        &self.inner
    }
    
    pub fn as_bytes(&self) -> &[u8] {
        self.inner.as_bytes()
    }
}

impl Wrapper<T> {
    // as_ - returns reference to inner
    pub fn as_inner(&self) -> &T {
        &self.inner
    }
    
    pub fn as_inner_mut(&mut self) -> &mut T {
        &mut self.inner
    }
}
;
Ok(())
}
fn main() {}
