#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn process(input: Option<String>) -> Option<u32> {
    let Some(s) = input else { return None; };
    let Ok(n) = s.trim().parse::<u32>() else { return None; };
    if n == 0 {
        return None;
    }
    Some(n * 2)
}
;
Ok(())
}
fn main() {}
