#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
struct ImageData {
    data: [u8; 1024],
    width: u32,
    height: u32,
}

enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Text(String),
    Image(Box<ImageData>),  // Now just 8 bytes (pointer)
}

// Message is now ~32 bytes (String variant is largest)
let messages: Vec<Message> = vec![
    Message::Quit,  // Uses ~32 bytes
    Message::Quit,  // Uses ~32 bytes  
    Message::Move { x: 0, y: 0 },  // Uses ~32 bytes
];
;
Ok(())
}
fn main() {}
