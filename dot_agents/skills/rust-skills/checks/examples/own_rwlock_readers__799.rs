#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::sync::{Arc, RwLock};

// Multiple readers can proceed concurrently
let config = Arc::new(RwLock::new(Config::load()));

fn get_setting(config: &RwLock<Config>, key: &str) -> String {
    let guard = config.read().unwrap(); // Multiple threads can hold read lock
    guard.get(key).to_string()
}

fn update_setting(config: &RwLock<Config>, key: &str, value: &str) {
    let mut guard = config.write().unwrap(); // Exclusive access for writes
    guard.set(key, value);
}

// 100 threads reading = parallel execution
;
Ok(())
}
fn main() {}
