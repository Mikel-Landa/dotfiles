#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// These coercions happen automatically:
// Vec<T>  -> &[T]   (via Deref)
// String  -> &str   (via Deref)
// Box<T>  -> &T     (via Deref)
// Arc<T>  -> &T     (via Deref)

fn process(data: &[u8]) { /* ... */ }

let vec: Vec<u8> = vec![1, 2, 3];
let boxed: Box<[u8]> = vec.into_boxed_slice();
let arc: Arc<[u8]> = Arc::from(&[1, 2, 3][..]);

process(&vec);    // Works
process(&boxed);  // Works
process(&arc);    // Works
;
Ok(())
}
fn main() {}
