#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Put most common variants first
fn process_message(msg: Message) {
    match msg {
        // Most common - listed first
        Message::Data(d) => handle_data(d),
        Message::Heartbeat => (), // Second most common
        
        // Rare cases last
        Message::Error(e) => handle_error(e),
        Message::Shutdown => shutdown(),
    }
}
;
Ok(())
}
fn main() {}
