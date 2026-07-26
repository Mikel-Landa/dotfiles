#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
struct Email(String);

impl From<String> for Email {
    fn from(s: String) -> Self {
        Email(s)
    }
}

impl From<&str> for Email {
    fn from(s: &str) -> Self {
        Email(s.to_string())
    }
}

// All of these work
let e1 = Email::from("test@example.com");
let e2 = Email::from(String::from("test@example.com"));
let e3: Email = "test@example.com".into();
let e4: Email = String::from("test@example.com").into();
;
Ok(())
}
fn main() {}
