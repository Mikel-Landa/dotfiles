#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
impl HashMap<K, V> {
    // Returns Option - not just field access
    fn get(&self, key: &K) -> Option<&V> { }
    
    // Mutable variant
    fn get_mut(&mut self, key: &K) -> Option<&mut V> { }
}

impl Vec<T> {
    // Returns Option - bounds checked
    fn get(&self, index: usize) -> Option<&T> { }
}

impl Context {
    // Does computation/lookup, not just field access
    fn get_config(&self) -> Config {
        self.configs.get(&self.current_env).cloned().unwrap_or_default()
    }
}
;
Ok(())
}
fn main() {}
