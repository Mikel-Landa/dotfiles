#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn call_once_dyn(f: &dyn Fn() -> i32) -> i32 {
    f()
}

fn demo_ref() {
    let x = 7;
    let result = call_once_dyn(&|| x + 1);
    assert_eq!(result, 8);
}
;
Ok(())
}
fn main() {}
