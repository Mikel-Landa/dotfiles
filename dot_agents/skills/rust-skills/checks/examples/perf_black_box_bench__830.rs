#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
use std::hint::black_box;

fn main() {
    // In std since Rust 1.66
    let result = black_box(compute_something(black_box(input)));
}
