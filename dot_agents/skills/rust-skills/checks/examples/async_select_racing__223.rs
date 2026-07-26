#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// By default, select! randomly picks when multiple are ready
// Use biased mode for deterministic priority
select! {
    biased;  // Check branches in order
    
    msg = high_priority.recv() => handle_high(msg),
    msg = low_priority.recv() => handle_low(msg),
}

// Without biased, both channels have equal chance
// when both have messages ready
;
Ok(())
}
fn main() {}
