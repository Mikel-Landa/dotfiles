#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
use std::collections::VecDeque;

fn process_queue(items: impl IntoIterator<Item = String>) {
    // VecDeque: O(1) pop_front — the right tool for a FIFO queue.
    let mut queue: VecDeque<String> = items.into_iter().collect();
    while let Some(item) = queue.pop_front() {
        println!("processing: {item}");
    }
}

fn sliding_window_max(values: &[i32], k: usize) -> Vec<i32> {
    // VecDeque also shines as a fixed-size sliding window.
    let mut window: VecDeque<i32> = VecDeque::with_capacity(k);
    let mut result = Vec::with_capacity(values.len().saturating_sub(k) + 1);

    for &v in values {
        window.push_back(v);
        if window.len() > k {
            window.pop_front();
        }
        if window.len() == k {
            result.push(*window.iter().max().unwrap());
        }
    }
    result
}

fn main() {
    process_queue(["alpha".to_string(), "beta".to_string(), "gamma".to_string()]);

    let maxima = sliding_window_max(&[3, 1, 2, 5, 4], 3);
    println!("{maxima:?}"); // [3, 5, 5]
}
