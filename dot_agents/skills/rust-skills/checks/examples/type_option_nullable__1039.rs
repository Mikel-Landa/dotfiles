#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Option makes absence explicit
fn find_user(id: u64) -> Option<User> {
    users.get(&id).cloned()
}

// Must handle the None case
let user = find_user(42);
match user {
    Some(u) => println!("{}", u.name),
    None => println!("User not found"),
}

// Or use combinators
let name = find_user(42)
    .map(|u| u.name)
    .unwrap_or_else(|| "Unknown".to_string());
;
Ok(())
}
fn main() {}
