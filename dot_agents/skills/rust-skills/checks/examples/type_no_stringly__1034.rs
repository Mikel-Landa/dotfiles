#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Instead of string for email
struct Email(String);

impl Email {
    fn new(s: &str) -> Result<Self, ValidationError> {
        if is_valid_email(s) {
            Ok(Email(s.to_string()))
        } else {
            Err(ValidationError::InvalidEmail)
        }
    }
}

// Instead of string for UUID
struct UserId(uuid::Uuid);

// Instead of string for paths
struct ConfigPath(PathBuf);
;
Ok(())
}
fn main() {}
