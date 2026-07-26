#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// ✅ Can be Copy
#[derive(Clone, Copy)]
struct Color {
    r: u8,
    g: u8,
    b: u8,
    a: u8,
}

// ❌ Cannot be Copy - contains String
#[derive(Clone)]
struct Person {
    name: String,  // String is not Copy
    age: u32,
}

// ❌ Cannot be Copy - has Drop
struct FileHandle {
    fd: i32,
}
impl Drop for FileHandle {
    fn drop(&mut self) { /* close file */ }
}
;
Ok(())
}
fn main() {}
