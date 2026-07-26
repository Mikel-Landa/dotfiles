#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::sync::{Mutex, MutexGuard};

struct Transaction; // commits on drop

impl Drop for Transaction {
    fn drop(&mut self) {
        println!("transaction committed");
    }
}

struct DatabaseSession {
    // CORRECT: `transaction` is declared first, so it drops first
    // (commit happens), THEN `guard` drops (lock released).
    transaction: Transaction,
    guard: MutexGuard<'static, ()>,
}
;
Ok(())
}
fn main() {}
