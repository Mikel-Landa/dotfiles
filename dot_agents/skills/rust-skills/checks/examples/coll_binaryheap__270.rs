#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
use std::cmp::Reverse;
use std::collections::BinaryHeap;

#[derive(Eq, PartialEq, Ord, PartialOrd)]
struct Task {
    priority: u32, // higher = more urgent
    name: String,
}

fn run_scheduler(tasks: impl IntoIterator<Item = (u32, &'static str)>) {
    // BinaryHeap: O(log n) push and pop — max-priority task extracted first.
    let mut heap: BinaryHeap<Task> = tasks
        .into_iter()
        .map(|(priority, name)| Task {
            priority,
            name: name.to_string(),
        })
        .collect();

    while let Some(task) = heap.pop() {
        println!("running [priority={}]: {}", task.priority, task.name);
    }
}

fn top_k_largest(values: &[i32], k: usize) -> Vec<i32> {
    // Min-heap of size k using Reverse<i32>: keeps the k largest elements.
    let mut min_heap: BinaryHeap<Reverse<i32>> = BinaryHeap::with_capacity(k + 1);
    for &v in values {
        min_heap.push(Reverse(v));
        if min_heap.len() > k {
            min_heap.pop(); // discard the current minimum
        }
    }
    // Drain from min to max for a sorted result.
    let mut result: Vec<i32> = min_heap.into_iter().map(|Reverse(v)| v).collect();
    result.sort_unstable_by(|a, b| b.cmp(a));
    result
}

fn main() {
    run_scheduler([
        (3, "low priority task"),
        (10, "urgent task"),
        (7, "medium priority task"),
        (10, "equally urgent task"),
    ]);
    // Output order: urgent, equally urgent, medium, low

    let top3 = top_k_largest(&[4, 1, 9, 2, 7, 5, 8], 3);
    println!("top 3: {top3:?}"); // [9, 8, 7]
}
