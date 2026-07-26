#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use thiserror::Error;

#[derive(Error, Debug)]
enum MyError {
    #[error("io error")]
    Io(#[from] std::io::Error),  // Auto From impl
    
    #[error("parse error")]
    Parse(#[from] serde_json::Error),  // Auto From impl
}

fn process() -> Result<(), MyError> {
    // ? automatically converts io::Error to MyError via From
    let content = std::fs::read_to_string("file.txt")?;
    
    // ? automatically converts serde_json::Error to MyError
    let data: Data = serde_json::from_str(&content)?;
    
    Ok(())
}
;
Ok(())
}
fn main() {}
