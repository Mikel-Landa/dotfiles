#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Most flexible: accept anything that can become &str
fn process(input: impl AsRef<str>) {
    let s: &str = input.as_ref();
    // ...
}

process("literal");
process(String::from("owned"));
process(&some_string);
;
Ok(())
}
fn main() {}
