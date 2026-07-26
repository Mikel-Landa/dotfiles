#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
use std::collections::{BTreeSet, HashSet};

// O(n + m): build the set once, then test each user in O(1).
fn find_common(all_users: &[String], active_ids: &[String]) -> Vec<String> {
    let active: HashSet<&String> = active_ids.iter().collect();
    all_users
        .iter()
        .filter(|u| active.contains(u))
        .cloned()
        .collect()
}

// Dedup while preserving order: track seen items in a HashSet.
fn deduplicate_ordered(items: Vec<String>) -> Vec<String> {
    let mut seen = HashSet::with_capacity(items.len());
    items.into_iter().filter(|s| seen.insert(s.clone())).collect()
}

// Dedup into a sorted, unique collection — use BTreeSet.
fn unique_sorted(items: Vec<String>) -> Vec<String> {
    items.into_iter().collect::<BTreeSet<_>>().into_iter().collect()
}

fn main() {
    let users = vec!["alice".to_string(), "bob".to_string(), "carol".to_string()];
    let active = vec!["bob".to_string(), "carol".to_string(), "dave".to_string()];
    println!("{:?}", find_common(&users, &active)); // ["bob", "carol"]

    let raw = vec!["x".to_string(), "y".to_string(), "x".to_string(), "z".to_string()];
    println!("{:?}", deduplicate_ordered(raw)); // ["x", "y", "z"]
}
