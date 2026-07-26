#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Mutex poisoning indicates a bug elsewhere
let guard = mutex.lock().expect("mutex poisoned");

// Regex is known valid at compile time
let re = Regex::new(r"^\d{4}$").expect("invalid regex");

// Thread spawn failure is unrecoverable
let handle = thread::spawn(|| work()).expect("failed to spawn thread");

// Static data that must be valid
let config: Config = toml::from_str(EMBEDDED_CONFIG)
    .expect("embedded config is invalid");
;
Ok(())
}
fn main() {}
