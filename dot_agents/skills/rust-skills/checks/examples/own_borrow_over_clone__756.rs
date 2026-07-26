#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// 1. Need owned data for storage
struct Cache {
    data: HashMap<String, String>,
}

impl Cache {
    fn insert(&mut self, key: &str, value: &str) {
        // Clone needed - we're storing owned data
        self.data.insert(key.to_string(), value.to_string());
    }
}

// 2. Need to send across threads
fn spawn_worker(data: &Config) {
    let owned = data.clone();  // Clone needed for 'static
    std::thread::spawn(move || {
        use_config(owned);
    });
}

// 3. Copy types (no heap allocation)
let x: i32 = 42;
let y = x;  // Copy, not clone - this is fine
;
Ok(())
}
fn main() {}
