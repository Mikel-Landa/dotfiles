#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::cell::Cell;

thread_local! {
    static CALL_COUNT: Cell<u32> = Cell::new(0);
}

fn record_call() {
    CALL_COUNT.with(|c| c.set(c.get() + 1));
}

fn get_call_count() -> u32 {
    CALL_COUNT.with(|c| c.get())
}
;
Ok(())
}
fn main() {}
