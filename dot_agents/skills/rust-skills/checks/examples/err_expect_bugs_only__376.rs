#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
struct ValidatedEmail(String);

impl ValidatedEmail {
    pub fn new(email: &str) -> Result<Self, EmailError> {
        // Validation happens here, returns Result
        if !is_valid_email(email) {
            return Err(EmailError::Invalid);
        }
        Ok(ValidatedEmail(email.to_string()))
    }
    
    pub fn domain(&self) -> &str {
        // After validation, expect() is fine
        self.0.split('@').nth(1)
            .expect("BUG: ValidatedEmail must contain @")
    }
}
;
Ok(())
}
fn main() {}
