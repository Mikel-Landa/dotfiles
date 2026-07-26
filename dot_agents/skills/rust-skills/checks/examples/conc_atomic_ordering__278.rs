#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::sync::atomic::{AtomicU64, AtomicBool, Ordering};

static COUNTER: AtomicU64 = AtomicU64::new(0);

// Relaxed: no ordering relative to other memory — fine for independent counters
fn increment() {
    COUNTER.fetch_add(1, Ordering::Relaxed);
}

fn total() -> u64 {
    COUNTER.load(Ordering::Relaxed)
}

// Acquire/Release: paired handoff — producer writes data THEN sets flag (Release);
// consumer loads flag (Acquire) and is guaranteed to see the preceding write.
static READY: AtomicBool = AtomicBool::new(false);
static VALUE: AtomicU64 = AtomicU64::new(0);

fn producer(value: u64) {
    VALUE.store(value, Ordering::Relaxed);   // write payload first
    READY.store(true, Ordering::Release);    // publish with Release
}

fn consumer() -> Option<u64> {
    if READY.load(Ordering::Acquire) {       // synchronize with Release store
        Some(VALUE.load(Ordering::Relaxed))  // payload visible after Acquire
    } else {
        None
    }
}

// SeqCst: only when you need a single total order across *multiple* atomics.
// Example: Dekker-style mutual exclusion involving two independent flags.
;
Ok(())
}
fn main() {}
