#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Accept anything that can be viewed as a slice
fn process<T: AsRef<[u8]>>(data: T) {
    let bytes: &[u8] = data.as_ref();
    // ...
}

process(&[1u8, 2, 3]);       // Array
process(vec![1u8, 2, 3]);    // Vec
process(&some_vec);          // &Vec
process(b"bytes");           // Byte string
;
Ok(())
}
fn main() {}
