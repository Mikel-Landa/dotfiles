#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// WARN: Should use if let
match option {
    Some(x) => do_something(x),
    None => {},
}
// Better: if let Some(x) = option { do_something(x) }

// WARN: Should use or_else
let value = if option.is_some() {
    option.unwrap()
} else {
    default()
};
// Better: option.unwrap_or_else(default)

// WARN: Collapsible if statements
if condition1 {
    if condition2 {
        do_something();
    }
}
// Better: if condition1 && condition2 { do_something() }
;
Ok(())
}
fn main() {}
