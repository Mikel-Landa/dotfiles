#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
struct UserId(u64);

// ✅ Implement From
impl From<u64> for UserId {
    fn from(id: u64) -> Self {
        UserId(id)
    }
}

// Into is automatically provided by blanket impl
let id: UserId = 42u64.into();  // Works!

// ❌ Don't implement Into directly
impl Into<UserId> for u64 {
    fn into(self) -> UserId {
        UserId(self)  // This works but is non-idiomatic
    }
}
;
Ok(())
}
fn main() {}
