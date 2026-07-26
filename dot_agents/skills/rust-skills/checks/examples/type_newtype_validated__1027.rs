#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct Email(String);

impl Email {
    pub fn new(s: &str) -> Result<Self, EmailError> {
        if is_valid_email(s) {
            Ok(Email(s.to_string()))
        } else {
            Err(EmailError::Invalid(s.to_string()))
        }
    }
    
    pub fn as_str(&self) -> &str {
        &self.0
    }
}

// No validation needed - Email is always valid
fn send_email(to: &Email, body: &str) -> Result<(), Error> {
    // to is guaranteed valid
    send_to_address(to.as_str(), body)
}

fn add_recipient(list: &mut Vec<Email>, email: Email) {
    // email is guaranteed valid
    list.push(email);
}
;
Ok(())
}
fn main() {}
