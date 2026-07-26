#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// unwrap_or - provide default
let x = opt.unwrap_or(default);

// unwrap_or_default - use Default trait
let x = opt.unwrap_or_default();

// unwrap_or_else - compute default lazily
let x = opt.unwrap_or_else(|| expensive_default());

// ? operator - propagate errors
let x = opt.ok_or(Error::Missing)?;

// if let - handle Some/Ok case
if let Some(x) = opt {
    use_x(x);
}

// match - handle all cases
match opt {
    Some(x) => use_x(x),
    None => handle_none(),
}

// map - transform if present
let y = opt.map(|x| x + 1);

// and_then - chain fallible operations
let z = opt.and_then(|x| x.checked_add(1));
;
Ok(())
}
fn main() {}
