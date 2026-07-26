#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
#[derive(Debug)]
struct Document {
    id: u64,              // Cheap to copy
    content: String,      // Expensive to clone
    metadata: Metadata,   // Moderate cost
}

impl Clone for Document {
    fn clone(&self) -> Self {
        Self {
            id: self.id,
            content: self.content.clone(),
            metadata: self.metadata.clone(),
        }
    }
    
    // Optimization: reuse existing allocations
    fn clone_from(&mut self, source: &Self) {
        self.id = source.id;
        self.content.clone_from(&source.content); // Reuses capacity
        self.metadata.clone_from(&source.metadata);
    }
}
;
Ok(())
}
fn main() {}
