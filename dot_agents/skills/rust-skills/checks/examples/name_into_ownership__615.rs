#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
impl Wrapper {
    // into_ clearly shows ownership transfer
    fn into_inner(self) -> Inner {
        self.inner
    }
}

// Usage is clear
let wrapper = Wrapper::new(inner);
let inner = wrapper.into_inner();  // wrapper is consumed
// wrapper.foo();  // Error: use of moved value
;
Ok(())
}
fn main() {}
