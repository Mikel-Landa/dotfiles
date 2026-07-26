#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Option<&T> for optional borrows
fn get(&self, key: &str) -> Option<&Value> {
    self.map.get(key)
}

// as_ref() to borrow Option contents
let opt: Option<String> = Some("hello".to_string());
let opt_ref: Option<&String> = opt.as_ref();
let opt_str: Option<&str> = opt.as_deref();

// as_mut() for mutable borrow
let mut opt = Some(vec![1, 2, 3]);
if let Some(v) = opt.as_mut() {
    v.push(4);
}
;
Ok(())
}
fn main() {}
