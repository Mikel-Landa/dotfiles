#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::cell::Cell;

struct Counter {
    count: Cell<u32>,
}

impl Counter {
    fn bump(&self) {
        self.count.set(self.count.get() + 1); // mutate through &self, never panics
    }
}
;
Ok(())
}
fn main() {}
