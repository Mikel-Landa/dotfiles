#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// Create a private module with a private trait
mod private {
    pub trait Sealed {}
}

// Public trait requires the private trait
pub trait DatabaseDriver: private::Sealed {
    fn connect(&self, url: &str) -> Connection;
    fn execute(&self, query: &str) -> Result<Rows, Error>;
}

// Only your crate can implement Sealed, thus DatabaseDriver
pub struct PostgresDriver;
impl private::Sealed for PostgresDriver {}
impl DatabaseDriver for PostgresDriver {
    fn connect(&self, url: &str) -> Connection { ... }
    fn execute(&self, query: &str) -> Result<Rows, Error> { ... }
}

pub struct MySqlDriver;
impl private::Sealed for MySqlDriver {}
impl DatabaseDriver for MySqlDriver {
    fn connect(&self, url: &str) -> Connection { ... }
    fn execute(&self, query: &str) -> Result<Rows, Error> { ... }
}

// External crate cannot implement - private::Sealed is not accessible
// impl DatabaseDriver for ExternalDriver { }  // Error!

// But external code CAN use the trait
fn use_driver(driver: &impl DatabaseDriver) {
    let conn = driver.connect("postgres://localhost");
}
fn main() {}
