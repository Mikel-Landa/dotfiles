#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// broadcast: subscribers get ALL messages
// Good for: events, logs, notifications
let (tx, _) = broadcast::channel::<Event>(100);

// watch: subscribers get LATEST value only
// Good for: config changes, state updates
let (tx, _) = watch::channel(initial_state);

// If subscriber is slow:
// - broadcast: they receive old messages (or lag)
// - watch: they skip to latest (no history)
;
Ok(())
}
fn main() {}
