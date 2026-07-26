#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
use serde::{Serialize, Deserialize};
use serde_json;

#[derive(Debug, Clone)]
struct Email(String);

impl TryFrom<String> for Email {
    type Error = String;

    fn try_from(s: String) -> Result<Self, Self::Error> {
        if s.contains('@') && !s.starts_with('@') && !s.ends_with('@') {
            Ok(Email(s))
        } else {
            Err(format!("invalid email address: {s}"))
        }
    }
}

// For the serialize direction: implement From<Email> for String, then add into = "String"
impl From<Email> for String {
    fn from(e: Email) -> String {
        e.0
    }
}

// Deserialize: serde reads a String, then calls Email::try_from — error if invalid.
// Serialize:   serde calls String::from(email) — converts back to the raw type.
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(try_from = "String", into = "String")]
struct ValidatedEmail(String);

impl TryFrom<String> for ValidatedEmail {
    type Error = String;

    fn try_from(s: String) -> Result<Self, Self::Error> {
        if s.contains('@') && !s.starts_with('@') && !s.ends_with('@') {
            Ok(ValidatedEmail(s))
        } else {
            Err(format!("invalid email address: {s}"))
        }
    }
}

impl From<ValidatedEmail> for String {
    fn from(e: ValidatedEmail) -> String {
        e.0
    }
}

fn main() {
    // Valid email round-trips fine
    let good = serde_json::from_str::<ValidatedEmail>("\"user@example.com\"").unwrap();
    println!("{}", serde_json::to_string(&good).unwrap());

    // Invalid email is rejected at parse time — never enters the program
    let bad = serde_json::from_str::<ValidatedEmail>("\"notanemail\"");
    assert!(bad.is_err());
}
