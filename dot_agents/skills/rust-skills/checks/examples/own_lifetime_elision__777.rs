#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
   fn foo(&self, x: &str) -> &str
   // becomes
   fn foo<'a, 'b>(&'a self, x: &'b str) -> &'a str
;
Ok(())
}
fn main() {}
