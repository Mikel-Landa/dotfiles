#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Create benchmarks that match real usage patterns

// Good: actual data samples
fn profile_workload() {
    for file in real_customer_data_samples() {
        process_file(&file);
    }
}

// Good: synthetic but realistic
fn profile_synthetic() {
    for _ in 0..10000 {
        let data = generate_realistic_data();
        process(&data);
    }
}

// Bad: artificial microbenchmarks
fn profile_bad() {
    for _ in 0..1000000 {
        small_operation();  // Doesn't reflect real hot paths
    }
}
;
Ok(())
}
fn main() {}
