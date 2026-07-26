#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// https://github.com/tokio-rs/tokio/blob/master/benches/sync_mpsc.rs
use criterion::{criterion_group, criterion_main, Criterion};

fn send_data<T: Default, const SIZE: usize>(
    g: &mut BenchmarkGroup<WallTime>, 
    prefix: &str
) {
    let rt = rt();
    g.bench_function(format!("{prefix}_{SIZE}"), |b| {
        b.iter(|| {
            let (tx, mut rx) = mpsc::channel::<T>(SIZE);
            rt.block_on(tx.send(T::default())).unwrap();
            rt.block_on(rx.recv()).unwrap();
        })
    });
}
;
Ok(())
}
fn main() {}
