#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use thiserror::Error;

#[derive(Error, Debug)]
pub enum AppError {
    #[error("failed to load config from {path}")]
    ConfigLoad {
        path: String,
        #[source]
        cause: std::io::Error,
    },
    
    #[error("failed to connect to database")]
    Database {
        #[source]
        cause: sqlx::Error,
    },
}

// Usage
fn load_config(path: &str) -> Result<Config, AppError> {
    let content = std::fs::read_to_string(path)
        .map_err(|e| AppError::ConfigLoad {
            path: path.to_string(),
            cause: e,
        })?;
    // ...
}
;
Ok(())
}
fn main() {}
