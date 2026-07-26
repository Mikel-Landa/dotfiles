#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::fmt;

// A local newtype wrapping the foreign type.
// `#[repr(transparent)]` guarantees the same memory layout as Vec<i32>.
#[repr(transparent)]
struct CommaSeparated(Vec<i32>);

impl CommaSeparated {
    pub fn new(v: Vec<i32>) -> Self { Self(v) }

    // Provide access to the inner value.
    pub fn into_inner(self) -> Vec<i32> { self.0 }
    pub fn inner(&self) -> &Vec<i32> { &self.0 }
}

// Now both the trait (Display) is foreign and the type (CommaSeparated) is local —
// the orphan rule is satisfied because CommaSeparated is defined here.
impl fmt::Display for CommaSeparated {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let mut iter = self.0.iter().peekable();
        while let Some(n) = iter.next() {
            write!(f, "{n}")?;
            if iter.peek().is_some() {
                write!(f, ", ")?;
            }
        }
        Ok(())
    }
}

// Implement From/Into so conversion is ergonomic.
impl From<Vec<i32>> for CommaSeparated {
    fn from(v: Vec<i32>) -> Self { Self(v) }
}

impl From<CommaSeparated> for Vec<i32> {
    fn from(w: CommaSeparated) -> Self { w.0 }
}

fn demo() {
    let nums = CommaSeparated::new(vec![1, 2, 3, 4, 5]);
    println!("{nums}");   // "1, 2, 3, 4, 5"

    // Round-trip through the inner type.
    let v: Vec<i32> = nums.into();
    let again = CommaSeparated::from(v);
    println!("{again}");
}
;
Ok(())
}
fn main() {}
