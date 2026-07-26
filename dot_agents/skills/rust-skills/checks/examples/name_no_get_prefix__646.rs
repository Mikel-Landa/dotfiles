#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
impl Config {
    // Getter: no prefix
    fn timeout(&self) -> Duration {
        self.timeout
    }
    
    // Setter: use set_ prefix
    fn set_timeout(&mut self, timeout: Duration) {
        self.timeout = timeout;
    }
}
;
Ok(())
}
fn main() {}
