#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
struct Event {
    timestamp: u64,
    kind: EventKind,
    payload: [u8; 32],
}

// Static assertion - breaks compile if size changes
const _: () = assert!(std::mem::size_of::<Event>() == 48);

// Or with static_assertions crate
use static_assertions::assert_eq_size;
assert_eq_size!(Event, [u8; 48]);

// Now adding metadata triggers compile error:
// error: assertion failed: std::mem::size_of::<Event>() == 48
;
Ok(())
}
fn main() {}
