#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Internal function - concrete type is fine
fn process_orders(db: &PostgresDb, orders: Vec<Order>) { }

// Public API - might benefit from abstraction
pub fn process_orders<S: Storage>(storage: &S, orders: Vec<Order>) { }
;
Ok(())
}
fn main() {}
