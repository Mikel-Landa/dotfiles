#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
struct UserId(u64);

// Idiomatic: implement From
impl From<u64> for UserId {
    fn from(id: u64) -> Self {
        UserId(id)
    }
}

// Now both work automatically
let id = UserId::from(42);   // From syntax
let id: UserId = 42.into();  // Into syntax (via blanket impl)

// And Into bound works in generics
fn process(id: impl Into<UserId>) {
    let id: UserId = id.into();
}
process(42u64);  // Works!
;
Ok(())
}
fn main() {}
