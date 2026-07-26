#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn process_header(data: &[u8]) -> Option<Header> {
    // Slice pattern - single length check, no per-field checks
    let [a, b, c, d, rest @ ..] = data else {
        return None;
    };
    
    Some(Header {
        magic: *a,
        version: *b,
        flags: u16::from_le_bytes([*c, *d]),
        payload: rest,
    })
}
;
Ok(())
}
fn main() {}
