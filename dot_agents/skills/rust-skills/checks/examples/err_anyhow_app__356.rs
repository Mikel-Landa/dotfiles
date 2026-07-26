#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use anyhow::{Context, Result};

fn load_config() -> Result<Config> {
    let path = find_config()
        .context("failed to locate config file")?;
    
    let content = std::fs::read_to_string(&path)
        .with_context(|| format!("failed to read config from {}", path.display()))?;
    
    let config: Config = toml::from_str(&content)
        .context("failed to parse config as TOML")?;
    
    validate(&config)
        .context("config validation failed")?;
    
    Ok(config)
}

// Error message: "config validation failed: field 'port' must be > 0"
// Full chain preserved for debugging
;
Ok(())
}
fn main() {}
