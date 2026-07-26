#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::fs::File;
use tokio::io::{AsyncReadExt, AsyncWriteExt, AsyncBufReadExt, BufReader};

// Read with buffer
let mut file = File::open("large.bin").await?;
let mut buffer = vec![0u8; 4096];
let bytes_read = file.read(&mut buffer).await?;

// Read all
let mut contents = Vec::new();
file.read_to_end(&mut contents).await?;

// Write
let mut file = File::create("output.bin").await?;
file.write_all(b"data").await?;
file.flush().await?;

// Buffered line reading
let file = File::open("lines.txt").await?;
let reader = BufReader::new(file);
let mut lines = reader.lines();

while let Some(line) = lines.next_line().await? {
    println!("{}", line);
}
;
Ok(())
}
fn main() {}
