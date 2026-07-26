#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
let col = Collection { items: vec![1, 2, 3] };

// These all work with proper IntoIterator impls
for item in &col {           // Calls (&col).into_iter() -> iter()
    println!("{}", item);    // &i32
}

for item in &mut col {       // Calls (&mut col).into_iter() -> iter_mut()
    *item += 1;              // &mut i32
}

for item in col {            // Calls col.into_iter()
    process(item);           // i32, consumes col
}
;
Ok(())
}
fn main() {}
