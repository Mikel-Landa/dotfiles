#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
pub mod db {
    mod private {
        pub trait Sealed {}
    }
    
    /// Database driver trait.
    /// 
    /// This trait is sealed and cannot be implemented outside this crate.
    pub trait Driver: private::Sealed {
        /// Connects to the database.
        fn connect(&self, url: &str) -> Result<Connection, Error>;
        
        /// Executes a query.
        fn execute(&self, sql: &str) -> Result<Rows, Error>;
    }
    
    pub struct Postgres;
    impl private::Sealed for Postgres {}
    impl Driver for Postgres { ... }
    
    pub struct Sqlite;
    impl private::Sealed for Sqlite {}
    impl Driver for Sqlite { ... }
}

// Usage works fine
use db::{Driver, Postgres};

fn query(driver: &impl Driver) {
    driver.execute("SELECT 1")?;
}

query(&Postgres);
fn main() {}
