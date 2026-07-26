#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
enum Message {
    // Unit variant
    Quit,
    
    // Tuple variant
    Move(i32, i32),
    
    // Struct variant
    Write { text: String },
    
    // Named fields
    ChangeColor {
        red: u8,
        green: u8,
        blue: u8,
    },
}
;
Ok(())
}
fn main() {}
