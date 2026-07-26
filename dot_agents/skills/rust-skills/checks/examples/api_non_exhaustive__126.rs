#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
pub enum Message {
    // Specific variant is non-exhaustive
    #[non_exhaustive]
    Error { code: u32, message: String },
    
    Ok(Data),
}

// Can destructure Ok normally
// But Error requires `..` to handle future fields
match msg {
    Message::Ok(data) => {},
    Message::Error { code, message, .. } => {},  // `..` required
}
;
Ok(())
}
fn main() {}
