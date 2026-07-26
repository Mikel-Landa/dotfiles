#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::task::JoinSet;

let mut set: JoinSet<(usize, Result<Data, Error>)> = JoinSet::new();

for (index, url) in urls.iter().enumerate() {
    let url = url.clone();
    set.spawn(async move {
        (index, fetch(&url).await)
    });
}

// Results include their index
while let Some(result) = set.join_next().await {
    if let Ok((index, data)) = result {
        results[index] = Some(data);
    }
}
;
Ok(())
}
fn main() {}
