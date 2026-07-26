#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// These give the compiler much better opportunities to eliminate bounds checks
// (and often do in practice), but elimination is not guaranteed — verify hot
// code with generated assembly (e.g. cargo-show-asm):

// zip - parallel iteration
for (a, b) in xs.iter().zip(ys.iter()) { ... }

// enumerate - index + value  
for (i, x) in data.iter().enumerate() { ... }

// windows - sliding window
for window in data.windows(3) { ... }

// chunks - fixed-size groups
for chunk in data.chunks(4) { ... }
for chunk in data.chunks_exact(4) { ... }  // Guarantees exact size

// split_at - divide slice
let (left, right) = data.split_at(mid);
;
Ok(())
}
fn main() {}
