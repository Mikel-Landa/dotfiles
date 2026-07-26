#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Vec
let mut v = Vec::with_capacity(100);
v.reserve(50);        // Ensure at least 50 more slots
v.reserve_exact(50);  // Ensure exactly 50 more (no extra)
v.shrink_to_fit();    // Release unused capacity

// String
let mut s = String::with_capacity(100);
s.reserve(50);

// HashMap / HashSet
let mut m = HashMap::with_capacity(100);
m.reserve(50);

// VecDeque
let mut d = VecDeque::with_capacity(100);
;
Ok(())
}
fn main() {}
