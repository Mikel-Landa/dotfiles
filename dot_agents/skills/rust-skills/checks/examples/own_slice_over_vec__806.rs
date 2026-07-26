#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Bad
fn read_config(path: &PathBuf) -> Config { /* ... */ }

// Good - accepts &Path, &PathBuf, &str, &String
fn read_config(path: &Path) -> Config { /* ... */ }

// Even better - accept anything path-like
fn read_config(path: impl AsRef<Path>) -> Config {
    let path = path.as_ref();
    // ...
}
;
Ok(())
}
fn main() {}
