#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::cell::RefCell;
use std::fmt::Write; // for write! into the String buffer

thread_local! {
    static BUFFER: RefCell<String> = RefCell::new(String::with_capacity(256));
}

fn format_event(event: &Event) -> String {
    BUFFER.with(|buf| {
        let mut buf = buf.borrow_mut();
        buf.clear();
        write!(buf, "[{}] {}", event.level, event.message).unwrap();
        buf.clone()  // Still one allocation per call, but no parsing
    })
}
;
Ok(())
}
fn main() {}
