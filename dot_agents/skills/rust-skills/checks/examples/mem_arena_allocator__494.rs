#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use bumpalo::Bump;
use std::cell::RefCell;

thread_local! {
    static SCRATCH: RefCell<Bump> = RefCell::new(Bump::with_capacity(4 * 1024));
}

fn with_scratch<T>(f: impl FnOnce(&Bump) -> T) -> T {
    SCRATCH.with(|scratch| {
        let arena = scratch.borrow();
        let result = f(&arena);
        result
    })
}

fn reset_scratch() {
    SCRATCH.with(|scratch| {
        scratch.borrow_mut().reset();
    });
}

// Usage
fn process_batch(items: &[Item]) -> Vec<Output> {
    with_scratch(|arena| {
        let temp_data: Vec<&TempData> = items
            .iter()
            .map(|item| arena.alloc(compute_temp(item)))
            .collect();
        
        // Use temp_data...
        let result = finalize(&temp_data);
        
        reset_scratch();  // Reuse arena memory
        result
    })
}
;
Ok(())
}
fn main() {}
