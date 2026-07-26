#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// https://github.com/BurntSushi/ripgrep/blob/master/crates/printer/src/standard.rs

#[inline(always)]
fn write_prelude(
    &self,
    absolute_byte_offset: u64,
    line_number: Option<u64>,
    column: Option<u64>,
) -> io::Result<()> {
    // Hot path in printing matches
}

#[inline(always)]
fn write_line(&self, line: &[u8]) -> io::Result<()> {
    // Called for every line
}
;
Ok(())
}
fn main() {}
