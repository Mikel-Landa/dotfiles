#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use thiserror::Error;

#[derive(Error, Debug)]
pub enum ConfigError {
    #[error("failed to read file: {0}")]
    Io(#[from] std::io::Error),
    
    #[error("failed to parse config: {0}")]
    Parse(#[from] toml::de::Error),
    
    #[error("missing required field: {0}")]
    MissingField(String),
}

fn load_config(path: &str) -> Result<Config, ConfigError> {
    let content = std::fs::read_to_string(path)?;  // Io error
    let config: Config = toml::from_str(&content)?;  // Parse error
    if config.name.is_empty() {
        return Err(ConfigError::MissingField("name".into()));
    }
    Ok(config)
}
;
Ok(())
}
fn main() {}
