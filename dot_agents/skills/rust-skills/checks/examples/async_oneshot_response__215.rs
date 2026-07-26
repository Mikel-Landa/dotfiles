#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::time::{timeout, Duration};

async fn request_with_timeout(
    tx: &mpsc::Sender<Request>,
    key: &str,
) -> Result<Value, Error> {
    let (reply_tx, reply_rx) = oneshot::channel();
    
    tx.send(Request::Get {
        key: key.to_string(),
        reply: reply_tx,
    }).await.map_err(|_| Error::ServiceDown)?;
    
    timeout(Duration::from_secs(5), reply_rx)
        .await
        .map_err(|_| Error::Timeout)?
        .map_err(|_| Error::ServiceDown)?
        .ok_or(Error::NotFound)
}
;
Ok(())
}
fn main() {}
