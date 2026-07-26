#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Let compiler decide for most functions
pub fn get_name(&self) -> &str {
    &self.name
}

pub fn calculate_tax(amount: f64) -> f64 {
    amount * 0.1
}

// Only force inline for proven hot paths
impl Hasher for MyHasher {
    // Hasher::write is called millions of times in tight loops
    // Profiling showed 15% improvement from forced inlining
    #[inline(always)]
    fn write(&mut self, bytes: &[u8]) {
        // Very small, very hot
        self.state = self.state.wrapping_add(bytes.len() as u64);
    }
}
;
Ok(())
}
fn main() {}
