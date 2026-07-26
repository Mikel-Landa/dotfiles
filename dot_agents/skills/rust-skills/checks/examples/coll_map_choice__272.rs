#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// --- 1. HashMap: default, fast, unordered ---
use std::collections::HashMap;

fn total_scores<'a>(records: &[(&'a str, u32)]) -> HashMap<&'a str, u32> {
    let mut scores: HashMap<&'a str, u32> = HashMap::new();
    for &(name, score) in records {
        *scores.entry(name).or_insert(0) += score;
    }
    scores
}

// --- 2. BTreeMap: sorted keys, range queries ---
use std::collections::BTreeMap;

fn events_in_range(
    log: &BTreeMap<u64, String>,
    start: u64,
    end: u64,
) -> Vec<(&u64, &String)> {
    // range() is only possible because BTreeMap keeps keys sorted.
    log.range(start..=end).collect()
}

fn build_log() -> BTreeMap<u64, String> {
    let mut log = BTreeMap::new();
    log.insert(1_000, "server started".to_string());
    log.insert(2_000, "request received".to_string());
    log.insert(3_000, "response sent".to_string());
    log
}

// --- 3. IndexMap: insertion order + O(1) lookup ---
use indexmap::IndexMap;

fn parse_config(pairs: &[(&str, &str)]) -> IndexMap<String, String> {
    // Keys iterated in the order they were inserted — deterministic output.
    pairs
        .iter()
        .map(|(k, v)| (k.to_string(), v.to_string()))
        .collect()
}

fn main() {
    // BTreeMap range query
    let log = build_log();
    let window = events_in_range(&log, 1_000, 2_500);
    for (ts, msg) in window {
        println!("{ts}: {msg}");
    }

    // IndexMap preserves insertion order
    let cfg = parse_config(&[("host", "localhost"), ("port", "8080"), ("debug", "true")]);
    for (k, v) in &cfg {
        println!("{k} = {v}"); // always: host, port, debug
    }
}
