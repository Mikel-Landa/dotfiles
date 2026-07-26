#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
struct Config {
    // Field names can omit prefix
    enabled: bool,
    verbose: bool,
    debug: bool,
}

impl Config {
    // But methods should have prefix
    fn is_enabled(&self) -> bool {
        self.enabled
    }
    
    fn is_verbose(&self) -> bool {
        self.verbose
    }
}
;
Ok(())
}
fn main() {}
