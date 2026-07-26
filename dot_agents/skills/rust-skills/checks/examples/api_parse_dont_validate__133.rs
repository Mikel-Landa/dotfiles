#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Parse at the system boundary (API, CLI, config file)
fn handle_request(raw: RawRequest) -> Result<Response, Error> {
    // Parse ALL inputs upfront
    let email = Email::parse(&raw.email)?;
    let age = Age::parse(raw.age)?;
    let username = Username::parse(&raw.username)?;
    
    // Now work with validated types
    process_user(email, age, username)
}

fn process_user(email: Email, age: Age, username: Username) {
    // All inputs guaranteed valid - no checks needed
}
;
Ok(())
}
fn main() {}
