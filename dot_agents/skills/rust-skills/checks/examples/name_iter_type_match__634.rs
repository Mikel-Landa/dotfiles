#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Vec
impl<T> Vec<T> {
    fn iter(&self) -> Iter<'_, T> { }       // Returns Iter
    fn iter_mut(&mut self) -> IterMut<'_, T> { }  // Returns IterMut
}

impl<T> IntoIterator for Vec<T> {
    type IntoIter = IntoIter<T>;  // Returns IntoIter
}

// HashMap
impl<K, V> HashMap<K, V> {
    fn iter(&self) -> Iter<'_, K, V> { }
    fn keys(&self) -> Keys<'_, K, V> { }    // Returns Keys
    fn values(&self) -> Values<'_, K, V> { }  // Returns Values
    fn drain(&mut self) -> Drain<'_, K, V> { }  // Returns Drain
}
;
Ok(())
}
fn main() {}
