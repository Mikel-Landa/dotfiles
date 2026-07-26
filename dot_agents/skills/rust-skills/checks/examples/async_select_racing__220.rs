#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::select;

async fn fetch_with_timeout() -> Result<Data, Error> {
    select! {
        result = fetch_data() => result,
        _ = tokio::time::sleep(Duration::from_secs(5)) => {
            Err(Error::Timeout)
        }
    }
}

async fn fetch_with_fallback() -> Data {
    select! {
        result = fetch_primary() => {
            match result {
                Ok(data) => data,
                Err(_) => fetch_fallback().await.unwrap()
            }
        }
        _ = tokio::time::sleep(Duration::from_secs(1)) => {
            // Primary too slow, use fallback
            fetch_fallback().await.unwrap()
        }
    }
}
;
Ok(())
}
fn main() {}
