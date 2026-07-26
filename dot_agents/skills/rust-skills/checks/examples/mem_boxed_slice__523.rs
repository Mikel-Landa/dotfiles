#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
struct Document {
    // Box<[T]> signals "fixed size" - clear intent
    paragraphs: Box<[Paragraph]>,  // 16 bytes: ptr + len (as fat pointer)
}

fn load_document(data: &[u8]) -> Document {
    let paragraphs: Vec<Paragraph> = parse_paragraphs(data);
    Document { 
        paragraphs: paragraphs.into_boxed_slice()  // Shrinks + converts
    }
}
;
Ok(())
}
fn main() {}
