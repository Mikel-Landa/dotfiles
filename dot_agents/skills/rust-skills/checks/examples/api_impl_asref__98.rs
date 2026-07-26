#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
struct Name(String);

impl AsRef<str> for Name {
    fn as_ref(&self) -> &str {
        &self.0
    }
}

impl AsRef<[u8]> for Name {
    fn as_ref(&self) -> &[u8] {
        self.0.as_bytes()
    }
}

// Now Name works with functions expecting AsRef<str>
fn greet(name: impl AsRef<str>) {
    println!("Hello, {}!", name.as_ref());
}

greet(Name("Alice".into()));
;
Ok(())
}
fn main() {}
