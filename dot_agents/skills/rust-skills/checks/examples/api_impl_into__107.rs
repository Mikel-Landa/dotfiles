#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// AsRef<T>: borrow as &T, no conversion cost
fn count_bytes(data: impl AsRef<[u8]>) -> usize {
    data.as_ref().len()  // Just borrows, no allocation
}
count_bytes("hello");  // &str -> &[u8]
count_bytes(b"hello"); // &[u8] -> &[u8]
count_bytes(vec![1, 2, 3]);  // &Vec<u8> -> &[u8]

// Into<T>: convert to owned T, may allocate
fn store_data(data: impl Into<Vec<u8>>) {
    let owned: Vec<u8> = data.into();  // Takes ownership
    // ...
}
;
Ok(())
}
fn main() {}
