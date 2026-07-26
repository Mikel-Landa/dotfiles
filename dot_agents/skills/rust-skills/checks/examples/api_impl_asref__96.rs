#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Accept anything that can be viewed as the target type
fn process_text(text: impl AsRef<str>) {
    let s: &str = text.as_ref();
    println!("{}", s);
}

fn read_file(path: impl AsRef<Path>) -> io::Result<Vec<u8>> {
    std::fs::read(path.as_ref())
}

// All of these work:
process_text("literal");        // &str
process_text(String::from("owned"));  // String
process_text(Cow::from("cow")); // Cow<str>

read_file("/path/to/file");     // &str  
read_file(Path::new("/path"));  // &Path
read_file(PathBuf::from("/path")); // PathBuf
read_file(OsStr::new("/path")); // &OsStr
;
Ok(())
}
fn main() {}
