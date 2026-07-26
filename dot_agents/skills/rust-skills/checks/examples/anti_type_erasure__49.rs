#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// impl Trait - zero overhead, inlined
fn get_iterator() -> impl Iterator<Item = i32> {
    (0..10).map(|x| x * 2)
}

// impl Fn - no boxing
fn make_handler() -> impl Fn(i32) -> i32 {
    |x| x + 1
}

// When mixed types are genuinely needed, Box is OK
fn get_validators() -> Vec<Box<dyn Validator>> {
    // Actually different types at runtime - Box is appropriate
    config.validators.iter()
        .map(|v| v.create_validator())
        .collect()
}
;
Ok(())
}
fn main() {}
