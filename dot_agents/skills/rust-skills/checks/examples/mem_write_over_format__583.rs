#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::fmt::Write;

struct Formatter {
    buffer: String,
}

impl Formatter {
    fn new() -> Self {
        Self { buffer: String::with_capacity(1024) }
    }
    
    fn format_event(&mut self, event: &Event) -> &str {
        self.buffer.clear();  // Reuse allocation
        write!(
            &mut self.buffer, 
            "[{}] {}",
            event.timestamp, 
            event.message
        ).unwrap();
        &self.buffer
    }
}

// Usage
let mut formatter = Formatter::new();
for event in events {
    let formatted = formatter.format_event(event);
    send_log(formatted);
}
;
Ok(())
}
fn main() {}
