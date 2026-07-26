#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Heterogeneous collection of different types
let handlers: Vec<Box<dyn Handler>> = vec![
    Box::new(LogHandler),
    Box::new(MetricsHandler),
    Box::new(AuthHandler),
];

// Type cannot be known at compile time
fn create_from_config(config: &Config) -> Box<dyn Database> {
    match config.db_type {
        DbType::Postgres => Box::new(PostgresDb::new()),
        DbType::Sqlite => Box::new(SqliteDb::new()),
    }
}

// Recursive types
struct Node {
    value: i32,
    children: Vec<Box<dyn NodeTrait>>,
}

// Breaking cycles in complex ownership
struct EventLoop {
    handlers: Vec<Box<dyn EventHandler>>,
}
;
Ok(())
}
fn main() {}
