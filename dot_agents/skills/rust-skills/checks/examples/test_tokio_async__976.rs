#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::sync::mpsc;

#[tokio::test]
async fn test_channel_communication() {
    let (tx, mut rx) = mpsc::channel(10);
    
    tokio::spawn(async move {
        tx.send("hello").await.unwrap();
        tx.send("world").await.unwrap();
    });
    
    assert_eq!(rx.recv().await, Some("hello"));
    assert_eq!(rx.recv().await, Some("world"));
    assert_eq!(rx.recv().await, None);
}
;
Ok(())
}
fn main() {}
