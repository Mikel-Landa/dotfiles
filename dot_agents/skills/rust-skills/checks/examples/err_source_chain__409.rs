#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use thiserror::Error;

#[derive(Error, Debug)]
enum MyError {
    // #[from] = implements From + sets source
    #[error("IO error")]
    Io(#[from] std::io::Error),
    
    // #[source] = only sets source (no From impl)
    #[error("Parse error in file '{path}'")]
    Parse {
        path: String,
        #[source]
        source: serde_json::Error,
    },
}
;
Ok(())
}
fn main() {}
