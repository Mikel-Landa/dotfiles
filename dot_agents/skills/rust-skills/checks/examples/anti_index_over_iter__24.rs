#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Need index in output
for (i, item) in items.iter().enumerate() {
    println!("{}: {}", i, item);
}

// Non-sequential access
for i in (0..len).step_by(2) {
    swap(&mut data[i], &mut data[i + 1]);
}

// Multi-dimensional iteration
for i in 0..rows {
    for j in 0..cols {
        matrix[i][j] = i * cols + j;
    }
}
;
Ok(())
}
fn main() {}
