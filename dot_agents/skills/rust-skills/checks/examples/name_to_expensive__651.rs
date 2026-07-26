#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
struct Email(String);

impl Email {
    // Cheap: just returns reference
    fn as_str(&self) -> &str {
        &self.0
    }
    
    // Expensive: allocates
    fn to_lowercase(&self) -> Email {
        Email(self.0.to_lowercase())
    }
    
    // Expensive: allocates
    fn to_display_format(&self) -> String {
        format!("<{}>", self.0)
    }
    
    // Ownership transfer: usually cheap
    fn into_string(self) -> String {
        self.0
    }
}
;
Ok(())
}
fn main() {}
