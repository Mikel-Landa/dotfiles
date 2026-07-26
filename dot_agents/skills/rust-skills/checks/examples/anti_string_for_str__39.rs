#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Accept &str - works with String, &str, literals
fn greet(name: &str) {
    println!("Hello, {}", name);
}

// All these work
greet("Alice");           // String literal
greet(&name);             // &String coerces to &str
greet(name.as_str());     // Explicit &str

// In struct
impl Config {
    fn set_name(&mut self, name: &str) {
        self.name = name.to_string();
    }
    
    // Or accept owned String if caller usually has one
    fn set_name_owned(&mut self, name: String) {
        self.name = name;
    }
    
    // Or be generic
    fn set_name_into(&mut self, name: impl Into<String>) {
        self.name = name.into();
    }
}
;
Ok(())
}
fn main() {}
