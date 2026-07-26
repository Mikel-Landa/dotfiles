#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
let result: Result<i32, Error> = Ok(42);

// map: transform success value
let doubled = result.map(|n| n * 2);  // Ok(84)

// map_err: transform error
let with_context = result.map_err(|e| format!("Failed: {}", e));

// and_then: chain fallible operations
let processed = result.and_then(|n| {
    if n > 0 { Ok(n * 2) } else { Err(Error::Negative) }
});

// unwrap_or: provide default on error
let value = result.unwrap_or(0);

// ok(): convert to Option, discarding error
let maybe_value: Option<i32> = result.ok();
;
Ok(())
}
fn main() {}
