#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// sqlx parses SQL at compile time, ensuring query validity
// https://github.com/launchbadge/sqlx/blob/master/src/macros/mod.rs

// The query! macro parses and validates SQL
let user = sqlx::query!("SELECT * FROM users WHERE id = ?", id)
    .fetch_one(&pool)
    .await?;

// If SQL is invalid, compilation fails - invalid state unrepresentable
;
Ok(())
}
fn main() {}
