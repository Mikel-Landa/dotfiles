#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
let cell = RefCell::new(5);
let borrow1 = cell.borrow();
let borrow2 = cell.borrow_mut(); // PANIC: already borrowed
;
Ok(())
}
fn main() {}
