#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Derive when all fields need cloning
#[derive(Clone)]
struct Simple {
    data: Vec<u8>,
    name: String,
}

// Manual when you need special behavior
struct CachedValue {
    value: i32,
    cache: RefCell<Option<ExpensiveComputation>>,
}

impl Clone for CachedValue {
    fn clone(&self) -> Self {
        Self {
            value: self.value,
            cache: RefCell::new(None), // Don't clone cache, let it rebuild
        }
    }
}
;
Ok(())
}
fn main() {}
