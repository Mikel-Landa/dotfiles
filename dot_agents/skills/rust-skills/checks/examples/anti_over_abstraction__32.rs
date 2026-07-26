#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Version 1: Just FileStorage
struct FileStorage { /* ... */ }

// Version 2: Added MemoryStorage, similar interface
struct MemoryStorage { /* ... */ }

// Version 3: Now Redis too - time to abstract
trait Storage {
    fn save(&self, key: &str, value: &[u8]) -> Result<()>;
    fn load(&self, key: &str) -> Result<Vec<u8>>;
}
;
Ok(())
}
fn main() {}
