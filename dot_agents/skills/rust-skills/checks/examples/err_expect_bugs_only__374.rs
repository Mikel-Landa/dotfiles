#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Invariant: after insert, key exists
fn cache_and_get(&mut self, key: String, value: Value) -> &Value {
    self.cache.insert(key.clone(), value);
    self.cache.get(&key)
        .expect("BUG: key must exist immediately after insert")
}

// Invariant: regex is compile-time constant
fn create_parser() -> Regex {
    Regex::new(r"^\d{4}-\d{2}-\d{2}$")
        .expect("BUG: date regex is invalid - this is a compile-time constant")
}

// Invariant: already validated
fn process_validated(data: ValidatedData) -> Result<Output, ProcessError> {
    let value = data.required_field
        .expect("BUG: ValidatedData guarantees required_field is Some");
    // ...
}

// Invariant: type system guarantees
fn get_first<T>(vec: Vec<T>) -> T 
where 
    Vec<T>: NonEmpty,  // Hypothetical trait
{
    vec.into_iter().next()
        .expect("BUG: NonEmpty Vec cannot be empty")
}
;
Ok(())
}
fn main() {}
