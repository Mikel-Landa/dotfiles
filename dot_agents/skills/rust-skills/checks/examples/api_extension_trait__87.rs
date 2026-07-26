#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
pub trait VecExt<T> {
    fn push_if_unique(&mut self, item: T)
    where
        T: PartialEq;
}

impl<T> VecExt<T> for Vec<T> {
    fn push_if_unique(&mut self, item: T)
    where
        T: PartialEq,
    {
        if !self.contains(&item) {
            self.push(item);
        }
    }
}

// Works with any T: PartialEq
let mut v = vec![1, 2, 3];
v.push_if_unique(2);  // No-op
v.push_if_unique(4);  // Adds 4
;
Ok(())
}
fn main() {}
