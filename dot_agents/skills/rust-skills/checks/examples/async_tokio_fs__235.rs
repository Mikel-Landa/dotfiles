#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::fs;

// Reading
let contents = fs::read_to_string("file.txt").await?;
let bytes = fs::read("file.bin").await?;

// Writing
fs::write("output.txt", "contents").await?;

// File operations
let file = fs::File::open("file.txt").await?;
let file = fs::File::create("new.txt").await?;

// Directory operations
fs::create_dir("new_dir").await?;
fs::create_dir_all("nested/dir/path").await?;
fs::remove_dir("empty_dir").await?;
fs::remove_dir_all("dir_with_contents").await?;

// Metadata
let metadata = fs::metadata("file.txt").await?;
let canonical = fs::canonicalize("./relative").await?;

// Rename/remove
fs::rename("old.txt", "new.txt").await?;
fs::remove_file("file.txt").await?;

// Read directory
let mut entries = fs::read_dir("some_dir").await?;
while let Some(entry) = entries.next_entry().await? {
    println!("{}", entry.path().display());
}
;
Ok(())
}
fn main() {}
