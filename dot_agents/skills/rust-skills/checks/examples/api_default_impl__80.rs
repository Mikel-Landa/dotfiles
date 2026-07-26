#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// When some fields have no sensible default, don't implement Default
struct User {
    id: UserId,       // No sensible default
    name: String,     // Could default to ""
}

// Instead, provide a constructor
impl User {
    fn new(id: UserId, name: impl Into<String>) -> Self {
        User { id, name: name.into() }
    }
}

// Or use a builder that accepts required fields at creation.
struct UserBuilder {
    id: UserId,
    name: String,
}

impl User {
    fn builder(id: UserId) -> UserBuilder {
        UserBuilder {
            id,
            name: String::new(),
        }
    }
}

impl UserBuilder {
    fn name(mut self, name: impl Into<String>) -> Self {
        self.name = name.into();
        self
    }

    fn build(self) -> User {
        User {
            id: self.id,
            name: self.name,
        }
    }
}
;
Ok(())
}
fn main() {}
