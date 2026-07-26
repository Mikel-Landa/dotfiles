#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// to_owned() for getting owned version of borrowed data
let borrowed: &str = "hello";
let owned: String = borrowed.to_owned();  // Allocates

let borrowed: &[i32] = &[1, 2, 3];
let owned: Vec<i32> = borrowed.to_owned();  // Allocates

// ToOwned trait
trait ToOwned {
    type Owned;
    fn to_owned(&self) -> Self::Owned;
}
;
Ok(())
}
fn main() {}
