#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// AsyncFn bound: concise, correct lifetime semantics, accepts async closures
async fn retry<F, T, E>(times: usize, f: F) -> Result<T, E>
where
    F: AsyncFn() -> Result<T, E>,
{
    let mut last_err;
    let mut i = 0;
    loop {
        match f().await {
            Ok(v) => return Ok(v),
            Err(e) => {
                last_err = e;
                i += 1;
                if i >= times {
                    return Err(last_err);
                }
            }
        }
    }
}

// callers can pass plain async functions or async closures
async fn fetch_data() -> Result<String, std::io::Error> {
    Ok("data".to_owned())
}

async fn example() {
    // async function reference
    let _ = retry(3, fetch_data).await;

    // async closure (impossible with the old F: Fn() -> Fut pattern
    // when the closure borrows a local across calls)
    let prefix = "prefix".to_owned();
    let _ = retry(3, async || {
        Ok::<_, std::io::Error>(format!("{prefix}-data"))
    })
    .await;
}
;
Ok(())
}
fn main() {}
