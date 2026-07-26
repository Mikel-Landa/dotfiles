#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Don't: expect on user data
let port: u16 = input.parse().expect("Invalid port");

// Do: Return Result
let port: u16 = input.parse().map_err(|_| ConfigError::InvalidPort)?;

// Do: Provide default
let port: u16 = input.parse().unwrap_or(8080);

// Do: Handle explicitly
let port: u16 = match input.parse() {
    Ok(p) => p,
    Err(_) => {
        log::warn!("Invalid port '{}', using default", input);
        8080
    }
};
;
Ok(())
}
fn main() {}
