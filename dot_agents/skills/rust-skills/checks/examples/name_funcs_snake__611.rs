#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// snake_case for functions
fn calculate_total() -> f64 { ... }
fn get_user_name() -> String { ... }
fn fetch_order() -> Order { ... }

// snake_case for methods
impl User {
    fn full_name(&self) -> String { ... }
    fn is_active(&self) -> bool { ... }
    fn set_email(&mut self, email: &str) { ... }
}

// snake_case for variables
let user_count = 42;
let max_connections = 100;
let is_valid = true;

// snake_case for modules
mod user_service;
mod http_client;
mod json_parser;
fn main() {}
