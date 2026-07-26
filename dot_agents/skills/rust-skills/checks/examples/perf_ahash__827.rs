#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// ahash: randomized seed per process, DoS-resistant, ~2x faster than SipHash.
// Good default replacement for most use cases.
use ahash::AHashMap;

fn build_id_map_ahash(ids: &[(u32, String)]) -> AHashMap<u32, String> {
    ids.iter().cloned().collect()
}

// FxHashMap (rustc-hash): fastest option, but uses a predictable hash function.
// Only for trusted integer or pointer keys where hash flooding is not a concern
// (e.g., compiler internals, in-process caches keyed by integer IDs).
use rustc_hash::FxHashMap;

type NodeMap<V> = FxHashMap<u32, V>;

fn build_node_map(nodes: &[(u32, String)]) -> NodeMap<String> {
    let mut map = NodeMap::with_capacity_and_hasher(
        nodes.len(),
        Default::default(),
    );
    map.extend(nodes.iter().cloned());
    map
}

// Convenient type aliases to avoid repeating the hasher parameter
use std::collections::HashMap;
use rustc_hash::FxBuildHasher;

type FastMap<K, V> = HashMap<K, V, FxBuildHasher>;

fn fast_map_example() -> FastMap<u32, u64> {
    FastMap::with_capacity_and_hasher(64, FxBuildHasher)
}
;
Ok(())
}
fn main() {}
