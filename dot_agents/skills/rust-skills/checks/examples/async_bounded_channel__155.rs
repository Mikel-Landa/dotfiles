#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Too small: frequent blocking, reduced throughput
let (tx, rx) = mpsc::channel::<Item>(1);

// Too large: delayed backpressure, memory waste
let (tx, rx) = mpsc::channel::<Item>(1_000_000);

// Guidelines:
// - Start with expected burst size
// - Measure actual usage in production
// - Err on the smaller side initially

// Small items, high throughput
let (tx, rx) = mpsc::channel::<u64>(1000);

// Large items, moderate throughput  
let (tx, rx) = mpsc::channel::<LargeStruct>(100);

// Low latency requirement
let (tx, rx) = mpsc::channel::<Command>(10);
;
Ok(())
}
fn main() {}
