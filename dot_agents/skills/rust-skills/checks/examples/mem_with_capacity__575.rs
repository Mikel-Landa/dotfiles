#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Pre-allocate exact size
let mut results = Vec::with_capacity(1000);
for i in 0..1000 {
    results.push(process(i));  // Zero reallocations!
}

// Or use collect with size hint (iterator provides capacity)
let results: Vec<_> = (0..1000).map(process).collect();

// Pre-allocate string
let estimated_len = words.iter().map(|w| w.len() + 1).sum();
let mut output = String::with_capacity(estimated_len);
for word in words {
    output.push_str(word);
    output.push(' ');
}

// Pre-allocate HashMap
let mut map = HashMap::with_capacity(pairs.len());
for (k, v) in pairs {
    map.insert(k, v);
}
;
Ok(())
}
fn main() {}
