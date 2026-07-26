#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Derive: all fields use their own Default
#[derive(Default)]
struct Simple {
    count: u32,      // 0
    name: String,    // ""
    items: Vec<i32>, // []
}

// Manual: when you need custom defaults
struct Connection {
    host: String,
    port: u16,
    timeout: Duration,
}

impl Default for Connection {
    fn default() -> Self {
        Connection {
            host: "localhost".to_string(),
            port: 8080,
            timeout: Duration::from_secs(30),
        }
    }
}
;
Ok(())
}
fn main() {}
