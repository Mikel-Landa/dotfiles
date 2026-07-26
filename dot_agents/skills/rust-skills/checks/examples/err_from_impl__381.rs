#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
#[derive(Error, Debug)]
enum ConfigError {
    #[error("Failed to read config from '{path}': {source}")]
    ReadFailed {
        path: String,
        #[source]
        source: std::io::Error,
    },
}

// Can't use #[from] when you need extra context
fn load_config(path: &str) -> Result<Config, ConfigError> {
    let content = std::fs::read_to_string(path)
        .map_err(|source| ConfigError::ReadFailed {
            path: path.to_string(),
            source,
        })?;
    // ...
}

// Or use anyhow for ad-hoc context
use anyhow::{Context, Result};

fn load_config(path: &str) -> Result<Config> {
    let content = std::fs::read_to_string(path)
        .with_context(|| format!("Failed to read config from '{}'", path))?;
    // ...
}
;
Ok(())
}
fn main() {}
