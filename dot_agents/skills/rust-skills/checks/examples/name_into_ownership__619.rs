#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
struct Buffer {
    data: Vec<u8>,
    name: String,
}

impl Buffer {
    // as_ : free borrow, returns reference
    fn as_slice(&self) -> &[u8] {
        &self.data
    }
    
    // to_ : allocates, creates new value
    fn to_vec(&self) -> Vec<u8> {
        self.data.clone()
    }
    
    // into_ : consumes self, usually cheap
    fn into_inner(self) -> Vec<u8> {
        self.data
    }
    
    // into_ : can destructure into parts
    fn into_parts(self) -> (Vec<u8>, String) {
        (self.data, self.name)
    }
}
;
Ok(())
}
fn main() {}
