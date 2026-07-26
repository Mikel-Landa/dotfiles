#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::thread;

fn parallel_sum(data: &[i64]) -> i64 {
    let mid = data.len() / 2;
    let (left, right) = data.split_at(mid);

    thread::scope(|s| {
        let h1 = s.spawn(|| left.iter().sum::<i64>());
        let h2 = s.spawn(|| right.iter().sum::<i64>());
        h1.join().unwrap() + h2.join().unwrap()
    })
}

// Mutable borrows work too — as long as they don't alias
fn parallel_fill(left: &mut [u8], right: &mut [u8]) {
    thread::scope(|s| {
        s.spawn(|| left.fill(0xAA));
        s.spawn(|| right.fill(0xBB));
    });
    // both halves have been written; scope guarantees completion
}
;
Ok(())
}
fn main() {}
