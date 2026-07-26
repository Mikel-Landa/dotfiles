#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Let elision work when possible
fn first_word(s: &str) -> &str {  // Not fn first_word<'a>(s: &'a str) -> &'a str
    s.split_whitespace().next().unwrap_or("")
}

impl User {
    fn name(&self) -> &str {  // Elision handles this
        &self.name
    }
}
;
Ok(())
}
fn main() {}
