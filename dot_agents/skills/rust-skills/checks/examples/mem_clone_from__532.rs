#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use criterion::{black_box, criterion_group, Criterion};

fn bench_clone_patterns(c: &mut Criterion) {
    let source = "x".repeat(1000);
    
    c.bench_function("clone assignment", |b| {
        let mut buffer = String::new();
        b.iter(|| {
            buffer = black_box(&source).clone();
        });
    });
    
    c.bench_function("clone_from", |b| {
        let mut buffer = String::with_capacity(1000);
        b.iter(|| {
            buffer.clone_from(black_box(&source));
        });
    });
}
// clone_from is typically 2-3x faster for this pattern
;
Ok(())
}
fn main() {}
