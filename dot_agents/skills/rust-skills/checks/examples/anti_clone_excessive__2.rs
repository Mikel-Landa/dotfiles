#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Need owned data for async move
let name = name.clone();
tokio::spawn(async move {
    process(name).await;
});

// Storing in a new struct
struct Cache {
    data: String,
}
impl Cache {
    fn store(&mut self, data: &str) {
        self.data = data.to_string();  // Must own
    }
}

// Multiple owners (use Arc instead if frequent)
let shared = data.clone();
thread::spawn(move || use_data(shared));
;
Ok(())
}
fn main() {}
