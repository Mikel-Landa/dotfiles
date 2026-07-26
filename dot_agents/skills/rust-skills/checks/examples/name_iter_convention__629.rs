#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Vec, slice, arrays
vec.iter()      // &T
vec.iter_mut()  // &mut T
vec.into_iter() // T

// HashMap
map.iter()      // (&K, &V)
map.iter_mut()  // (&K, &mut V)
map.into_iter() // (K, V)
map.keys()      // &K
map.values()    // &V
;
Ok(())
}
fn main() {}
