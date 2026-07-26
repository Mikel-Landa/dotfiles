#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use thiserror::Error;

#[derive(Error, Debug)]
enum ConfigError {
    #[error("Failed to read config file: {0}")]
    Io(#[from] std::io::Error),
    #[error("Invalid config format: {0}")]
    Parse(#[from] serde_json::Error),
}

fn parse_config(path: &str) -> Result<Config, ConfigError> {
    let content = std::fs::read_to_string(path)?;
    let config = serde_json::from_str(&content)?;
    Ok(config)
}

fn divide(a: i32, b: i32) -> Result<i32, &'static str> {
    if b == 0 {
        return Err("Division by zero");
    }
    Ok(a / b)
}

// Caller decides how to handle
match parse_config("app.json") {
    Ok(config) => run_app(config),
    Err(e) => {
        eprintln!("Using default config: {}", e);
        run_app(Config::default())
    }
}
;
Ok(())
}
fn main() {}
