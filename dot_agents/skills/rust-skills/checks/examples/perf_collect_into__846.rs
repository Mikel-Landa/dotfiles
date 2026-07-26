#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::collections::{HashSet, HashMap, VecDeque};

let mut vec = Vec::new();
let mut set = HashSet::new();
let mut deque = VecDeque::new();

(0..10).collect_into(&mut vec);
(0..10).collect_into(&mut set);
(0..10).collect_into(&mut deque);
;
Ok(())
}
fn main() {}
