#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
enum Status {
    Active,
    Pending,
    Closed,
}

fn is_active(s: &Status) -> bool {
    matches!(s, Status::Active)
}

fn is_small_digit(n: u32) -> bool {
    matches!(n, 1..=9)
}

fn is_positive(opt: Option<i32>) -> bool {
    matches!(opt, Some(v) if v > 0)
}
;
Ok(())
}
fn main() {}
