#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
#[must_use = "builders do nothing unless consumed"]
struct ConfigBuilder {
    log_level: Level,
    max_connections: usize,
}

// Now all methods returning Self warn if ignored
impl ConfigBuilder {
    fn log_level(mut self, level: Level) -> Self {
        self.log_level = level;
        self
    }
    
    fn max_connections(mut self, n: usize) -> Self {
        self.max_connections = n;
        self
    }
    
    fn build(self) -> Config {
        Config {
            log_level: self.log_level,
            max_connections: self.max_connections,
        }
    }
}
;
Ok(())
}
fn main() {}
