#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
struct Config {
    name: String,
    path: PathBuf,
}

impl Config {
    fn new(name: impl Into<String>) -> Self {
        Config {
            name: name.into(),
            path: PathBuf::new(),
        }
    }
    
    fn path(mut self, path: impl Into<PathBuf>) -> Self {
        self.path = path.into();
        self
    }
}

// Clean builder calls
let config = Config::new("myapp")
    .path("/etc/myapp");
;
Ok(())
}
fn main() {}
