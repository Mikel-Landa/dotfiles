#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
struct User {
    name: String,
    email: String,
    phone: Option<String>,        // Optional field
    avatar_url: Option<Url>,      // Optional field
}

impl User {
    fn display_phone(&self) -> &str {
        self.phone.as_deref().unwrap_or("Not provided")
    }
}
;
Ok(())
}
fn main() {}
