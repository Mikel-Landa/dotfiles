#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
let collection = MyCollection { items: vec![1, 2, 3] };

// Explicit methods
for x in collection.iter() { }     // Borrows
for x in collection.iter_mut() { } // Mutably borrows

// IntoIterator enables for loop syntax
for x in &collection { }      // Calls (&collection).into_iter()
for x in &mut collection { }  // Calls (&mut collection).into_iter()
for x in collection { }       // Consumes, calls collection.into_iter()
;
Ok(())
}
fn main() {}
