#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// For values known at compile time
macro_rules! email {
    ($s:literal) => {{
        const _: () = assert!(is_valid_email_const($s));
        Email::new_unchecked($s)
    }};
}

let admin = email!("admin@example.com");  // Validated at compile time
;
Ok(())
}
fn main() {}
