#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use criterion::Throughput;

fn bench_parse(c: &mut Criterion) {
    let input = "a]ong string to parse...";
    
    let mut group = c.benchmark_group("Parser");
    group.throughput(Throughput::Bytes(input.len() as u64));
    
    group.bench_function("parse", |b| {
        b.iter(|| parse(black_box(input)))
    });
    
    group.finish();
}
;
Ok(())
}
fn main() {}
