#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn get_first_word(text: &str) -> Option<&str> {
    let first_line = text.lines().next()?;
    let first_word = first_line.split_whitespace().next()?;
    Some(first_word)
}

// Convert Option to Result
fn get_required_config(key: &str) -> Result<String, Error> {
    config.get(key)
        .cloned()
        .ok_or_else(|| Error::MissingConfig(key.to_string()))
}
;
Ok(())
}
fn main() {}
