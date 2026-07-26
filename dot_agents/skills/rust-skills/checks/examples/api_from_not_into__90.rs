#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// This is in std, you don't write it
impl<T, U> Into<U> for T
where
    U: From<T>,
{
    fn into(self) -> U {
        U::from(self)
    }
}

// So when you implement From:
impl From<String> for MyType { ... }

// You automatically get:
// impl Into<MyType> for String { ... }
;
Ok(())
}
fn main() {}
