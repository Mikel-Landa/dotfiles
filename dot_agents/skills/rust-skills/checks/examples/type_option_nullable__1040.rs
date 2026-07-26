#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// if let for single case
if let Some(user) = find_user(id) {
    process(user);
}

// Chaining with map
let upper_name = find_user(id)
    .map(|u| u.name)
    .map(|n| n.to_uppercase());

// Providing defaults
let user = find_user(id).unwrap_or_default();
let user = find_user(id).unwrap_or_else(|| User::guest());

// ? operator for propagation
fn get_user_email(id: u64) -> Option<String> {
    let user = find_user(id)?;
    Some(user.email)
}

// and_then for chained optionals
fn get_user_country(id: u64) -> Option<String> {
    find_user(id)
        .and_then(|u| u.address)
        .and_then(|a| a.country)
}
;
Ok(())
}
fn main() {}
