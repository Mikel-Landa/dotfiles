#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Cache with millions of entries
struct Cache {
    // 8 bytes saved per entry adds up
    entries: HashMap<Key, Box<[u8]>>,
}

impl Cache {
    fn insert(&mut self, key: Key, data: Vec<u8>) {
        // Convert to boxed slice for storage
        self.entries.insert(key, data.into_boxed_slice());
    }
    
    fn get(&self, key: &Key) -> Option<&[u8]> {
        // Returns regular slice reference
        self.entries.get(key).map(|b| b.as_ref())
    }
}
;
Ok(())
}
fn main() {}
